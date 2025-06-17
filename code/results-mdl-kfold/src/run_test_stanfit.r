args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 5) {
  stop("Usage: 
  Rscript script.R  <mdl_file>
                    <data_file>
                    <stanfit_file>
                    <output_file>
                    <FOLD>")
}

require(rstan)


#-------------------------
# Read the args
#-------------------------

model_file <- args[1]

data_file <- args[2]
stanfit_file <- args[3]
output_file <- args[4]
fold <- as.numeric(args[5])

#-------------------------
# Load 
#-------------------------

dat <- readRDS(data_file)
stanmodel <- readRDS(model_file)
stanfit <- readRDS(stanfit_file)

#-------------------------
# GQS 
#-------------------------

data <- dat[[fold]]
gqs_test <- gqs(
    stanmodel, 
    draws = as.matrix(stanfit), 
    data = data[['data_test']],
    seed = 12345
    )


#-------------------------
# Save
#-------------------------

saveRDS(gqs_test, file = output_file)
