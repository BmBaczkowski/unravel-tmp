#!/usr/local/bin/R

# Retrieve command-line arguments
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

if (length(file_list) < 4) {
  stop("Usage: 
  Rscript script.R <utils_file> <json_sidecar_script> <study_dir1> ... <json_sidecar_file>")
}

# Load utility functions
source(file_list[1])

# Load JSON sidecar script
source(file_list[2])

# Get list of study folders
study_dirs <- file_list[3:(length(file_list) - 1)]

# Define the path for the JSON sidecar file from the fourth argument
sidecar_path <- file_list[length(file_list)]

# Define the directory for saving processed TSV files
# This is derived from the directory of the JSON sidecar file
target_data_dir <- dirname(sidecar_path)
source_data_dir <- dirname(study_dirs[1])

# Load required packages
require(dplyr)    # For data manipulation
require(readr)    # For reading and writing TSV files
require(stringr)  # For string manipulation functions
require(tidyr) # pivot_wider

# Define a function to preprocess the data frame
preproc_df <- function(df, study) {
    df <- df %>%
        mutate(
            response = case_when(
                shock == 'absent' & response == 'correct' ~ 0,
                shock == 'absent' & response == 'incorrect' ~ 1,
                shock == 'present' & response == 'correct' ~ 1,
                shock == 'present' & response == 'incorrect' ~ 0
            ),
            shock = case_when(
                shock == 'absent' ~ 0, 
                shock == 'present' ~ 1 
            ),
            condition = case_when(
                condition == 'CSp' ~ 1,
                condition == 'CSm' ~ 2
            ),
            study_id = str_extract(study, "\\d+")
        ) %>%
        select(study_id, everything())

    df_csp <- df %>%
        filter(condition == 1) %>%
        select(study_id, participant_id, trial_id, shock, condition, response) %>%
        mutate(
            id = row_number()
        )

    df_csm <- df %>%
        filter(condition == 2) %>%
        select(study_id, participant_id, trial_id, shock, condition, response) %>%
        mutate(
            id = row_number()
        )

    df <- full_join(df_csp, df_csm, by = "id", keep=TRUE)

    df <- df %>%
        rename(
            study_id = study_id.x,
            participant_id = participant_id.x,
            trial_id = id.x,
            shock = shock.x,
            response_csp = response.x,
            response_csm = response.y
        ) %>%
        select(study_id, participant_id, trial_id, shock, response_csp, response_csm)
    # print(df_csp, n=60)
    # print(df_csm, n=60)
    # print(df, n=60)

    return(df)
}

# Define the main processing function
main <- function(source_sub_dir, target_sub_dir) {
    # Identify the source TSV file to be processed
    source_tsv_file <- list.files(
        path = source_sub_dir,
        pattern = ".*task-conditioning_beh\\.tsv$", 
        full.names = TRUE
    )

    cat("Processing file:", source_tsv_file, "\n")

    # Define target file names
    target_tsv_file <- gsub("_beh.tsv", "_desc-rl_beh.tsv", source_tsv_file)
    target_tsv_file <- gsub(source_sub_dir, target_sub_dir, target_tsv_file)
    target_json_file <- gsub("tsv", "json", target_tsv_file)

    # Extract study ID from source sub-directory name
    study_id <- str_extract(source_sub_dir, "study-\\d+")

    # Read the source TSV file
    df <- read_file(source_tsv_file)
    df <- preproc_df(df, study_id)  # Preprocess the data frame

    # Create the target directory if it does not exist
    if (!dir.exists(target_sub_dir)) {
        dir.create(target_sub_dir, recursive = TRUE, showWarnings = TRUE)
        cat("Directory created:", target_sub_dir, "\n")
    }
    
    # Write the processed data frame to a TSV file
    write_tsv(df, file = target_tsv_file, na = "n/a")

    # Get JSON sidecar string and write to file
    json_sidecar_string <- get_source_json_sidecar(source_tsv_file)
    write(json_sidecar_string, file = target_json_file)
}

# List all sub-directories under the source data directory
source_sub_dirs <- list()

# Loop through each folder and get sub-directories
for (folder in study_dirs) {
  sub_dirs <- list.dirs(path = folder, recursive = TRUE)
  
  # Append the result to the all_sub_dirs list
  source_sub_dirs <- c(source_sub_dirs, sub_dirs)
}

# Filter sub-directories to include only those related to subjects
source_sub_dirs <- grep("sub", source_sub_dirs, value = TRUE)

# Define corresponding target sub-directories
target_sub_dirs <- gsub(source_data_dir, target_data_dir, source_sub_dirs)

# Apply the main processing function to each pair of source and target directories
result <- Map(main, source_sub_dirs, target_sub_dirs)

# Write the JSON sidecar content to the specified file
write(sidecar, file = sidecar_path)
