args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 5) {
  stop("Usage: 
  Rscript script.R  <mdl_file>
                    <data_file>
                    <parnames_file>
                    <POSTERIOR|LARGE
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
mdl_type <- args[5]

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
# RUN
#-------------------------

if (mdl_type == "POSTERIOR"){
  n_thin <- 1
  n_iter <- 1e3 * n_thin
  n_burnin <- 5e2 * n_thin
  stanfit <- sampling(
      mdl, 
      data = data[['data_list']], 
      pars = parnames, 
      iter = n_iter + n_burnin, 
      warmup = n_burnin,
      thin = n_thin,
      chains = 4, 
      cores = parallel::detectCores(),
      seed = 12345, 
      init = "random", 
      algorithm = "NUTS"
    )
} else if (mdl_type == "LARGE"){
  n_thin <- 2
  n_iter <- 1e4 * n_thin
  n_burnin <- 1e3 * n_thin
  stanfit <- sampling(
      mdl, 
      data = data[['data_list']], 
      pars = parnames, 
      iter = n_iter + n_burnin, 
      warmup = n_burnin,
      thin = n_thin,
      chains = 4, 
      cores = parallel::detectCores(),
      seed = 12345, 
      init = "random", 
      algorithm = "NUTS",
      control = list(
        adapt_delta = 0.9
      )
    )
}

#-------------------------
# Save
#-------------------------

saveRDS(stanfit, file = output_file)
