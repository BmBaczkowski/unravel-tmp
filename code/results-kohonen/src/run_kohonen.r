#!/usr/local/bin/R

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop("Usage: 
  Rscript script.R  <stanfit>
                    <func_file>
                    <target_file>
                    <1HT|2HT|SDT>
                    ")
}


#-------------------------
# Read the args
#-------------------------

stanfit_file <- args[1]
func_file <- args[2]
target_file <- args[3]
mdl_type <- args[4]

#-------------------------
# Load 
#-------------------------

stanfit <- readRDS(stanfit_file)

som_func <- local({
  source(func_file, local = TRUE)
  get("get_som")
})

#-------------------------
# Save
#-------------------------

som_model <- som_func(stanfit, mdl_type)

saveRDS(som_model, file = target_file)
