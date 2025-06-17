args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop("Usage: 
  Rscript script.R  <samples_file>
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

samples_file <- args[1]
data_file <- args[2]
plot_func_file <- args[3]
target_file <- args[4]

#-------------------------
# Load 
#-------------------------

samples <- readRDS(samples_file)
data <- readRDS(data_file)
plot_func <- local({
  source(plot_func_file, local = TRUE)
  get("plot_func")
})

#-------------------------
# Get the plot
#-------------------------

plot_func(samples, data, target_file)

