#!/usr/local/bin/R

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 3) {
  stop("Usage: 
  Rscript script.R  <source_file>
                    <func_file>
                    <target_file>")
}

#-------------------------
# Read the args
#-------------------------

source_file <- args[1]
func_file <- args[2]
target_file <- args[3]

#-------------------------
# Load 
#-------------------------

get_data_func <- local({
  source(func_file, local = TRUE)
  get("get_data")
})

#-------------------------
# Save
#-------------------------

out <- get_data_func(source_file)

saveRDS(out, file = target_file)
