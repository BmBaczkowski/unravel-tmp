args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop("Usage: 
  Rscript script.R  <stan_file>
                    <output_file>")
}

require(rstan)

#-------------------------
# Read the args
#-------------------------

# Define jags model
model_file <- args[1]

# Define output file
output_file <- args[2]

#-------------------------
# Compile the model
#-------------------------

mdl <- stan_model(model_file)

#-------------------------
# Save
#-------------------------

saveRDS(mdl, file = output_file)
