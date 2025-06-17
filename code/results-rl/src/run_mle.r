args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 3) {
  stop("Usage: 
  Rscript script.R  <mdl_file>
                    <data_file>
                    <output_file>")
}

require(rstan)


#-------------------------
# Read the args
#-------------------------

model_file <- args[1]
data_file <- args[2]
output_file <- args[3]

#-------------------------
# Load 
#-------------------------

data <- readRDS(data_file)
mdl <- readRDS(model_file)

#-------------------------
# MLE
#-------------------------

# Use the 'optimizing' function to get MLE
mle_fit <- optimizing(
    mdl,                     
    data = data[['data_list']], 
    init = "random",          # Initial values
    algorithm = "LBFGS",      # Optimization algorithm
    hessian = TRUE,           # Calculate the Hessian matrix (optional)
    seed = 12345,             # Random seed for reproducibility,
    iter = 2e3                # default number of iterations
)

#-------------------------
# Save
#-------------------------

saveRDS(mle_fit, file = output_file)

