args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop("Usage: 
  Rscript script.R  <stanmodel>
                    <mle_fit>
                    <data_file>
                    <output_file>")
}

require(rstan)


#-------------------------
# Read the args
#-------------------------

model_file <- args[1]
mle_file <- args[2]
data_file <- args[3]
output_file <- args[4]

#-------------------------
# Load 
#-------------------------

data <- readRDS(data_file)
mdl <- readRDS(model_file)
mle_fit <- readRDS(mle_file)

#-------------------------
# MLE
#-------------------------

mle_params <- mle_fit$par
parnames <- names(mle_params)

pattern <- "^alpha\\[\\d+\\]"
indx <- grep(pattern, parnames)

# Create a list for the fixed data, including the MLE parameters
fixed_data <- data[['data_list']]
fixed_data[['alpha']] <- as.vector(mle_params[indx])
# fixed_data[['mu_alpha']] <- as.vector(mle_params['mu_alpha'])
# fixed_data[['tau_alpha']] <- as.vector(mle_params['tau_alpha'])

# Run Stan to sample from generated quantities
fit_generated <- sampling(
  mdl, 
  data = fixed_data, 
  algorithm = "Fixed_param",  # Use the fixed_param algorithm
  iter = 1e3,                 # Number of iterations
  seed = 12345,
  cores = parallel::detectCores()
)

# Extract the samples
generated_quantities <- extract(fit_generated, pars = c("response_csp_pred", "response_csm_pred"))

#-------------------------
# Save
#-------------------------

saveRDS(generated_quantities, file = output_file)

