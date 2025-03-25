#!/usr/bin/env Rscript

# This script extracts and processes conditioning task data from original CSV files acquired in exp1, exp2, exp3, and exp4. 
# It performs the following actions:
# - Transforms the names of factor variables for better readability.
# - Saves the processed data into new TSV files formatted according to BIDS standard. 


# Retrieve command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if the correct number of arguments is provided
if (length(args) != 4) {
  stop("Usage: Rscript script.R <source_dir> <utils_file> <sidecar_source_file> <sidecar_target_file>")
}

# Define the folder path where CSV files are located
source_path <- args[1]

# Load utility functions from the specified file
source(args[2])

# Load JSON sidecar data from the specified source file
source(args[3])

# Define the path for the JSON sidecar target file
sidecar_path <- args[4]

# Define the folder path where new TSV files will be saved (target directory)
target_path <- dirname(sidecar_path)

# Load the dplyr package for data manipulation
require(dplyr)

# Function to preprocess the dataframe
preproc_df <- function(df, vp) {
    df <- df %>%
        mutate(
            # Add participant_id and format trial_id and item_id with leading zeros
            participant_id = vp,
            trial_id = zero_pad_number(trial, 3),
            item_id = zero_pad_number(num, 3),
            # Determine condition based on shockedCategory
            condition = case_when(
                str_detect(shockedCategory, object) ~ "CSp",
                TRUE ~ "CSm"
            ),
            # Determine shock presence
            shock = case_when(
                toShock == 1 ~ "present",
                toShock == 0 ~ "absent",
            ),
            # Determine response correctness
            response = case_when(
                    isResponseCorrect == 0 ~ "incorrect",
                    isResponseCorrect == 1 ~ "correct",
                    TRUE ~ NA_character_
            ),
            # Round reaction time to 3 decimal places if response is not NA
            RT = case_when(
                is.na(response) ~ NA_real_,
                TRUE ~ round(reactionTime, 3)
            )) %>%
        # Rename 'object' column to 'category'
        rename(
            category = object
        ) %>%
        # Select and order columns for the final dataframe
        select(
            participant_id, 
            trial_id, 
            category, 
            item_id, 
            condition,
            shock,
            response, 
            RT)
    return(df)
}

# Main function to process each CSV file and save the results
main <- function(csvfile, output_path) {
    message("Processing file: ", csvfile)
    # Read the CSV file using the read_file function
    result <- read_file(csvfile)
    # Preprocess the dataframe using the preproc_df function
    df <- preproc_df(result$df, result$vp)
    # Create a subdirectory for the participant if it doesn't exist
    subdir <- file.path(output_path, sprintf("sub-%s", result$vp))
    if (!dir.exists(subdir)) {
        dir.create(subdir)
        cat("Directory created:", subdir, "\n")
    }
    # Define the output file path and write the dataframe to a TSV file
    outfile <- file.path(subdir, sprintf("sub-%s_task-conditioning_beh.tsv", result$vp))
    write_tsv(df, outfile, na="n/a")

    # Define output file path for the json sidecar and write to a JSON file
    path_parts <- strsplit(csvfile, split = "/")[[1]]
    csvfile_stripped <- file.path(path_parts[2], path_parts[3])
    sidecar_source <- get_source_json_sidecar(csvfile_stripped)
    sidecar_source_path <- gsub("tsv", "json", outfile)
    write(sidecar_source, file = sidecar_source_path)
}

# List all CSV files in the source directory that match the pattern
csv_files <- list.files(source_path, pattern = ".*phase_2_.*\\.csv$", full.names = TRUE)

# Apply the main function to each CSV file
result <- mapply(main, csv_files, output_path = target_path, SIMPLIFY = FALSE)

# Write the updated JSON sidecar data to the target file
write(sidecar, file = sidecar_path)
