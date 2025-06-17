args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop("Usage: 
  Rscript script.R  <stanfit_file>
                    <data_file>
                    <plot_func_file>
                    <output_file>")
}

require(rstan)
require(bayesplot)
require(dplyr)
require(ggplot2)


#-------------------------
# Read the args
#-------------------------

stanfit_file <- args[1]
data_file <- args[2]
plot_func_file <- args[3]
target_file <- args[4]

#-------------------------
# Load 
#-------------------------

stanfit <- readRDS(stanfit_file)
data <- readRDS(data_file)
plot_func <- local({
  source(plot_func_file, local = TRUE)
  get("plot_func")
})

#-------------------------
# Get the plot
#-------------------------

plot_func(stanfit, data, target_file)

