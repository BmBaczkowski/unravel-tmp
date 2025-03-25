args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop("Usage: 
  Rscript script.R  <mdl_file>
                    <data_file>
                    <parnames_file>
                    <output_file>")
}

require(rstan)


#-------------------------
# Read the args
#-------------------------

model_file <- args[1]
data_file <- args[2]
parnames_file <- args[3]
output_file <- args[4]

#-------------------------
# Load 
#-------------------------

data <- readRDS(data_file)
mdl <- readRDS(model_file)
parnames <- local({
  source(parnames_file, local = TRUE)
  get("parnames")
})

#-------------------------
# Prior predictive only
#-------------------------

n_iter <- 5e3
fit <- sampling(
    mdl, 
    data = data[['data_list']], 
    pars = parnames, 
    iter = n_iter, 
    thin = 1,
    chains = 4, 
    cores = parallel::detectCores(),
    seed = 12345, 
    init = "random", 
    algorithm = "Fixed_param"
  )

#-------------------------
# Save
#-------------------------

saveRDS(fit, file = output_file)
