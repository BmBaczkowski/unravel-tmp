#!/usr/local/bin/R

# Reproduce overall performance.

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
  Rscript script.R <sidecar_script> <study_dir1> ... <sidecar_target_file>")
}

# Load necessary libraries
require(dplyr)
require(readr)
require(purrr)
require(tidyr)

# Load sidecar
json_sidecar <- local({
  source(file_list[1], local = TRUE)
  get("sidecar")
})

# Get list of study folders
study_dirs <- file_list[2:(length(file_list) - 1)]

# Define the path for the JSON sidecar file 
json_sidecar_file <-  file_list[length(file_list)]
target_tsv_file <- gsub("json", "tsv", json_sidecar_file)

source_tsv_files <- unlist(lapply(study_dirs, function(dirname) {
  list.files(
    path = dirname,
    pattern = ".*task-recognition_desc-reduced_beh\\.tsv$", 
    recursive = TRUE,
    full.names = TRUE
  )
}))

message("Loading individual tsv files...\n")

df <- source_tsv_files %>%
  map_dfr(~ read_tsv(., col_types = cols(
    study_id = col_character(),
    participant_id = col_character(),
    category = col_character(),
    condition = col_character(),
    first_presentation = col_character(),
    status = col_character(),
    n_old = col_double(),
    n_total = col_double()
  ), na="n/a"))

message("Files loaded and concatenated...\n")
message("Processing...\n")



df <- df %>%
  mutate(
    id = paste(participant_id, study_id, sep = "_"),
    proportion = round(n_old / n_total, 3),
  ) %>%
  pivot_wider(
    id_cols = c(id, study_id),
    names_from = c(condition, first_presentation),
    values_from = proportion
  ) %>%
  rename(
    CSm_fa = CSm_recognition,
    CSp_fa = CSp_recognition,
  )

df_sorted <- df %>%
  mutate(mean_fa = (CSm_fa + CSp_fa)/2) %>%
  arrange(mean_fa) 

write(json_sidecar, file = json_sidecar_file)
write_tsv(df_sorted, file = target_tsv_file, na="n/a")

