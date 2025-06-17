args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop("Usage: 
  Rscript script.R  <stanfit_file>
                    <parnames_file>
                    <plot_func_file>
                    <output_file>")
}

require(rstan)
require(coda)

#-------------------------
# Read the args
#-------------------------

stanfit_file <- args[1]
parnames_file <- args[2]
plot_func_file <- args[3]
target_file <- args[4]

#-------------------------
# Load 
#-------------------------

stanfit <- readRDS(stanfit_file)
get_parnames_func <- local({
  source(parnames_file, local = TRUE)
  get("get_parnames")
})
plot_mcmc_func <- local({
  source(plot_func_file, local = TRUE)
  get("plot_mcmc_chains")
})

#-------------------------
# Get the plot
#-------------------------

parnames <- get_parnames_func(stanfit)
samples <- As.mcmc.list(stanfit, pars=parnames)

# Open a PDF device
# pdf(file = target_file, width = 7, height = 5)  # Width and height are in inches
# pdf(file = target_file, width = 8.27, height = 11.69)  # Width and height are in inches
pdf(file = target_file)  # Width and height are in inches

for (parname in parnames) {
    message(sprintf("Plotting: %s \n", parname))
    plot_mcmc_func(samples, parname)
}

# Close the PDF device to save the plot
dev.off()

