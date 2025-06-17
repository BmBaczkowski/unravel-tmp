#!/usr/local/bin/Rscript

args <- commandArgs(trailingOnly = TRUE)

get_args <- function(...) {
  # Capture the arguments as a list
  args <- list(...)
  
  # Convert the list to numeric and calculate the sum
  file_list <- unlist(args)
  names(file_list) <- NULL

  return(file_list)
}

file_list <- get_args(... = args)

if (length(file_list) < 3) {
  stop("Usage: 
  Rscript script.R <study_dir1> ... <func_file> <target_file>")
}

#-------------------------
# Read the args
#-------------------------

study_dirs <- file_list[1:(length(file_list) - 2)]
func_file <- file_list[(length(file_list) - 1)]
target_file <- file_list[length(file_list)]

#-------------------------
# Load 
#-------------------------

source_tsv_files <- unlist(lapply(study_dirs, function(dirname) {
  list.files(
    path = dirname,
    pattern = ".*task-conditioning_desc-rl_beh\\.tsv$", 
    recursive = TRUE,
    full.names = TRUE
  )
}))

get_data_func <- local({
  source(func_file, local = TRUE)
  get("get_data")
})

#-------------------------
# Save
#-------------------------

out <- get_data_func(source_tsv_files)

saveRDS(out, file = target_file)
