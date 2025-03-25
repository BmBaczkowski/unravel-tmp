#!/usr/bin/env Rscript


# This script extracts and processes recognition task data from original CSV files acquired in exp1. 
# It performs the following actions:
# - Transforms the names of factor variables for better readability.
# - Filters reaction time and confidence rating based on whether 'old' / 'new' response was provided. 
# - Saves the processed data into new TSV files formatted according to BIDS standard. 


# Capture command line arguments provided when running the script
args <- commandArgs(trailingOnly = TRUE)

# Check if exactly 4 arguments are provided; if not, stop execution with usage message
if (length(args) != 4) {
  stop("Usage: Rscript script.R <source_dir> <utils_file> <sidecar_source_file> <sidecar_target_file>")
}

# Define the path to the folder containing CSV files based on the first argument
source_path <- args[1]

# Load utility functions from the file specified by the second argument
source(args[2])

# Load JSON sidecar data from the file specified by the third argument
source(args[3])

# Define the path where the sidecar data will be saved, based on the fourth argument
sidecar_path <- args[4]

# Define the path for saving processed TSV files by extracting directory name from sidecar path
target_path <- dirname(sidecar_path)

# Load the dplyr package for data manipulation
require(dplyr)

# Function to preprocess the dataframe
preproc_df <- function(df, vp) {
    df <- df %>%
        mutate(
            # Add participant_id column with value from vp
            participant_id = vp,
            # Format trial and num columns with zero padding
            trial_id = zero_pad_number(trial, 3),
            item_id = zero_pad_number(num, 3),
            # Assign condition based on the presence of object in shockedCategory
            condition = case_when(
                str_detect(shockedCategory, object) ~ "CSp",
                TRUE ~ "CSm"
            ),
            # Map phase values to descriptive item_first_presentation values
            item_first_presentation = case_when(
                    phase == 1 ~ "pre_conditioning",
                    phase == 2 ~ "conditioning",
                    phase == 3 ~ "post_conditioning",
                    phase == 4 ~ "recognition",
                    TRUE ~ NA_character_
            ),
            # Map buttonPressedForcedChoice values to response categories
            response = case_when(
                    buttonPressedForcedChoice == 1 ~ "old",
                    buttonPressedForcedChoice == 2 ~ "new",
                    TRUE ~ NA_character_
            ),
            # Round forcedChoiceRT to 3 decimal places if response is not NA
            RT_response = case_when(
                is.na(response) ~ NA_real_,
                TRUE ~ round(forcedChoiceRT, 3)
            ),
            # Map buttonPressedCertainty values to confidence categories
            confidence = case_when(
                    is.na(response) ~ NA_character_,
                    buttonPressedCertainty == 1 ~ "very_unsure",
                    buttonPressedCertainty == 2 ~ "rather_unsure",
                    buttonPressedCertainty == 3 ~ "rather_sure",
                    buttonPressedCertainty == 4 ~ "very_sure",
                    TRUE ~ NA_character_
            ),
            # Round certaintyRT to 3 decimal places if response is not NA
            RT_confidence = case_when(
                is.na(response) ~ NA_real_,
                TRUE ~ round(certaintyRT, 3)
            ),
            # Map seenBefore values to item_status categories
            item_status = case_when(
                seenBefore == 0 ~ "new",
                TRUE ~ "old"
            )) %>%
        # Rename column 'object' to 'category'
        rename(
            category = object
        ) %>%
        # Select and order columns for the final dataframe
        select(
            participant_id, 
            trial_id, 
            condition, 
            category, 
            item_id, 
            item_first_presentation, 
            item_status, 
            response, 
            RT_response, 
            confidence, 
            RT_confidence)
    return(df)
}

# Main function to process each CSV file
main <- function(csvfile, output_path) {
    message("Processing file: ", csvfile)

    
    
    # Read the CSV file and get the dataframe and participant ID
    result <- read_file(csvfile)
    df <- preproc_df(result$df, result$vp)
    
    # Create a subdirectory for the participant if it does not exist
    subdir <- file.path(output_path, sprintf("sub-%s", result$vp))
    if (!dir.exists(subdir)) {
        dir.create(subdir)
        cat("Directory created:", subdir, "\n")
    }
    
    # Define output file path and write the processed dataframe to a TSV file
    outfile_tsv <- file.path(subdir, sprintf("sub-%s_task-recognition_beh.tsv", result$vp))
    write_tsv(df, outfile_tsv, na="n/a")

    # Define output file path for the json sidecar and write to a JSON file
    path_parts <- strsplit(csvfile, split = "/")[[1]]
    csvfile_stripped <- file.path(path_parts[2], path_parts[3])
    sidecar_source <- get_source_json_sidecar(csvfile_stripped)
    sidecar_source_path <- gsub("tsv", "json", outfile_tsv)
    write(sidecar_source, file = sidecar_source_path)
}

# List all CSV files in the source directory with a specific pattern
csv_files <- list.files(source_path, pattern = ".*phase_4_.*\\.csv$", full.names = TRUE)

# Apply the main function to each CSV file and specify the output path
result <- mapply(main, csv_files, output_path = target_path, SIMPLIFY = FALSE)

# Write the JSON sidecar data to the specified file path
write(sidecar, file = sidecar_path)
