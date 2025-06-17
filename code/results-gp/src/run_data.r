#!/usr/local/bin/R

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop("Usage: 
  Rscript script.R  <standata>
                    <covariates>
                    <func_file>
                    <output_file>")
}

#-------------------------
# Read the args
#-------------------------

standata_file <- args[1]
covs_file <- args[2]
func_file <- args[3]
target_file <- args[4]


#-------------------------
# Load 
#-------------------------

standata <- readRDS(standata_file)
df_covs <- readRDS(covs_file)

get_data_func <- local({
  source(func_file, local = TRUE)
  get("get_data")
})

#-------------------------
# Save
#-------------------------

out <- get_data_func(standata, df_covs)

saveRDS(out, file = target_file)
