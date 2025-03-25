#!/usr/bin/env Rscript

# This script extracts and processes post-conditioning task data from original CSV files acquired in exp1, exp2, exp3, and exp4. 
# It performs the following actions:
# - Transforms the names of factor variables for better readability.
# - Saves the processed data into new TSV files formatted according to BIDS standard. 

# Retrieve command-line arguments passed to the script
args <- commandArgs(trailingOnly = TRUE)

# Check if exactly 4 arguments are provided; otherwise, stop execution and show usage
if (length(args) != 4) {
  stop("Usage: Rscript script.R <source_dir> <utils_file> <sidecar_source_file> <sidecar_target_file>")
}

# Define the path to the directory containing CSV files to be processed
source_path <- args[1]

# Load utility functions from the specified R script
source(args[2])

# Load JSON sidecar string from the specified file
source(args[3])

# Define the path where the JSON sidecar file will be saved
sidecar_path <- args[4]

# Define the directory path where the processed TSV files will be saved (same as sidecar file directory)
target_path <- dirname(sidecar_path)

# Load the dplyr package for data manipulation
require(dplyr)

# Function to preprocess the dataframe
preproc_df <- function(df, vp) {
    df <- df %>%
        mutate(
            # Add participant ID to the dataframe
            participant_id = vp,
            # Zero-pad trial and item numbers for consistent formatting
            trial_id = zero_pad_number(trial, 3),
            item_id = zero_pad_number(num, 3),
            # Convert response correctness to a descriptive string
            response = case_when(
                    isResponseCorrect == 0 ~ "incorrect",
                    isResponseCorrect == 1 ~ "correct",
                    TRUE ~ NA_character_  # Handle unexpected values
            ),
            # Round reaction time to 3 decimal places, if response is not NA
            RT = case_when(
                is.na(response) ~ NA_real_,
                TRUE ~ round(reactionTime, 3)
            )) %>%
        # Rename column 'object' to 'category'
        rename(
            category = object
        ) %>%
        # Select and order the columns for the final dataframe
        select(
            participant_id, 
            trial_id, 
            category, 
            item_id, 
            response, 
            RT)
    return(df)  # Return the processed dataframe
}

# Main function to process each CSV file and save the result as a TSV file
main <- function(csvfile, output_path) {
    message("Processing file: ", csvfile)  # Print the name of the file being processed
    result <- read_file(csvfile)  # Read the CSV file into a dataframe
    df <- preproc_df(result$df, result$vp)  # Preprocess the dataframe
    # Create a subdirectory for the participant if it doesn't already exist
    subdir <- file.path(output_path, sprintf("sub-%s", result$vp))
    if (!dir.exists(subdir)) {
        dir.create(subdir)
        cat("Directory created:", subdir, "\n")
    }
    # Define the output file path and write the processed dataframe to a TSV file
    outfile <- file.path(subdir, sprintf("sub-%s_task-postconditioning_beh.tsv", result$vp))
    write_tsv(df, outfile, na="n/a")

    # Define output file path for the json sidecar and write to a JSON file
    path_parts <- strsplit(csvfile, split = "/")[[1]]
    csvfile_stripped <- file.path(path_parts[2], path_parts[3])
    sidecar_source <- get_source_json_sidecar(csvfile_stripped)
    sidecar_source_path <- gsub("tsv", "json", outfile)
    write(sidecar_source, file = sidecar_source_path)
}

# List all CSV files in the source directory that match the specified pattern
csv_files <- list.files(source_path, pattern = ".*phase_3_.*\\.csv$", full.names = TRUE)

# Apply the main function to each CSV file, specifying the output directory for the TSV files
result <- mapply(main, csv_files, output_path = target_path, SIMPLIFY = FALSE)

# Write the JSON sidecar data to the specified file path
write(sidecar, file = sidecar_path)
