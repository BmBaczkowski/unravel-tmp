#!/usr/bin/env Rscript

# This script extracts and processes pre-conditioning task data from original CSV files acquired in exp1, exp2, exp3, and exp4. 
# It performs the following actions:
# - Transforms the names of factor variables for better readability.
# - Saves the processed data into new TSV files formatted according to BIDS standard. 

# Retrieve command-line arguments provided to the script
args <- commandArgs(trailingOnly = TRUE)

# Ensure exactly 4 arguments are supplied; otherwise, terminate the script and display usage instructions
if (length(args) != 4) {
  stop("Usage: Rscript script.R <source_dir> <utils_file> <sidecar_source_file> <sidecar_target_file>")
}

# Define the path to the directory containing CSV files that need to be processed
source_path <- args[1]

# Load utility functions from the specified R script; these functions are assumed to be defined in this file
source(args[2])

# Load the JSON sidecar string from the specified file; this will be used later for output
source(args[3])

# Define the path where the JSON sidecar file will be saved after processing
sidecar_path <- args[4]

# Define the folder path where new TSV files will be saved, which is the directory of the JSON sidecar file
target_path <- dirname(sidecar_path)

# Load the dplyr package for data manipulation tasks
require(dplyr)

# Define a function to preprocess the dataframe
preproc_df <- function(df, vp) {
    df <- df %>%
        mutate(
            # Add participant ID to the dataframe
            participant_id = vp,
            # Zero-pad trial and item numbers to a length of 3 for consistent formatting
            trial_id = zero_pad_number(trial, 3),
            item_id = zero_pad_number(num, 3),
            # Convert response correctness to descriptive labels
            response = case_when(
                    isResponseCorrect == 0 ~ "incorrect",
                    isResponseCorrect == 1 ~ "correct",
                    TRUE ~ NA_character_  # Handle any unexpected values
            ),
            # Round reaction time to 3 decimal places if a response is present
            RT = case_when(
                is.na(response) ~ NA_real_,
                TRUE ~ round(reactionTime, 3)
            )) %>%
        # Rename the column 'object' to 'category'
        rename(
            category = object
        ) %>%
        # Select and reorder the columns for the final output
        select(
            participant_id, 
            trial_id, 
            category, 
            item_id, 
            response, 
            RT)
    return(df)  # Return the processed dataframe
}

# Main function to process each CSV file and save the results to a TSV file
main <- function(csvfile, output_path) {
    message("Processing file: ", csvfile)  # Print the name of the currently processed file
    result <- read_file(csvfile)  # Read the CSV file into a dataframe and obtain participant ID
    df <- preproc_df(result$df, result$vp)  # Preprocess the dataframe using the preproc_df function
    # Create a subdirectory for the participant if it does not exist
    subdir <- file.path(output_path, sprintf("sub-%s", result$vp))
    if (!dir.exists(subdir)) {
        dir.create(subdir)  # Create the subdirectory
        cat("Directory created:", subdir, "\n")
    }
    # Define the output file path and save the processed dataframe as a TSV file
    outfile <- file.path(subdir, sprintf("sub-%s_task-preconditioning_beh.tsv", result$vp))
    write_tsv(df, outfile, na="n/a")  # Write the dataframe to a TSV file, using "n/a" for NA values

    # Define output file path for the json sidecar and write to a JSON file
    path_parts <- strsplit(csvfile, split = "/")[[1]]
    csvfile_stripped <- file.path(path_parts[2], path_parts[3])
    sidecar_source <- get_source_json_sidecar(csvfile_stripped)
    sidecar_source_path <- gsub("tsv", "json", outfile)
    write(sidecar_source, file = sidecar_source_path)
}

# List all CSV files in the source directory that match the pattern for phase 1 files
csv_files <- list.files(source_path, pattern = ".*phase_1_.*\\.csv$", full.names = TRUE)

# Apply the main function to each CSV file, specifying the output path for the TSV files
result <- mapply(main, csv_files, output_path = target_path, SIMPLIFY = FALSE)

# Write the JSON sidecar data to the specified file path
write(sidecar, file = sidecar_path)
