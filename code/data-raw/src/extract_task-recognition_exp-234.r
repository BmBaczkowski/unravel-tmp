#!/usr/local/bin/R

# This script extracts and processes recognition task data from original CSV files acquired in exp2, exp3, and expr4. 
# It performs the following actions:
# - Transforms the names of factor variables for better readability.
# - Filters reaction time and confidence rating based on whether 'old' / 'new' response was provided. 
# - Saves the processed data into new TSV files formatted according to BIDS standard. 


# Capture command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if the correct number of arguments is provided
if (length(args) != 4) {
  stop("Usage: Rscript script.R <source_dir> <utils_file> <sidecar_source_file> <sidecar_target_file>")
}

# Define the folder path where CSV files are located, taken from the first argument
source_path <- args[1]

# Load utility functions from the specified R script
source(args[2])

# Load JSON sidecar data from the specified R script
source(args[3])

# Define the path for the JSON sidecar output file, taken from the fourth argument
sidecar_path <- args[4]

# Define the folder path where new TSV files will be saved, based on the directory of the JSON sidecar file
target_path <- dirname(sidecar_path)

# Load the 'dplyr' package for data manipulation functions
require(dplyr)

# Function to preprocess the dataframe
preproc_df <- function(df, vp) {
    df <- df %>%
        mutate(
            # Add participant ID to the dataframe
            participant_id = vp,
            # Zero-pad trial and item numbers to 3 digits
            trial_id = zero_pad_number(trial, 3),
            item_id = zero_pad_number(num, 3),
            # Determine condition based on shockedCategory and object variables
            condition = case_when(
                str_detect(shockedCategory, object) ~ "CSp",
                TRUE ~ "CSm"
            ),
            # Categorize the item based on phase
            item_first_presentation = case_when(
                phase == 1 ~ "pre_conditioning",
                phase == 2 ~ "conditioning",
                phase == 3 ~ "post_conditioning",
                phase == 4 ~ "recognition",
                TRUE ~ NA_character_
            ),
            # Determine response based on buttonPressedCertainty
            response = case_when(
                buttonPressedCertainty == 1 ~ "old",
                buttonPressedCertainty == 2 ~ "old",
                buttonPressedCertainty == 3 ~ "new",
                buttonPressedCertainty == 4 ~ "new",
                TRUE ~ NA_character_
            ),
            # Determine confidence based on buttonPressedCertainty
            confidence = case_when(
                is.na(response) ~ NA_character_,
                buttonPressedCertainty == 1 ~ "definitely",
                buttonPressedCertainty == 2 ~ "maybe",
                buttonPressedCertainty == 3 ~ "maybe",
                buttonPressedCertainty == 4 ~ "definitely",
                TRUE ~ NA_character_
            ),
            # Round reaction time to 3 decimal places
            RT = case_when(
                is.na(response) ~ NA_real_,
                TRUE ~ round(certaintyRT, 3)
            ),
            # Determine item status based on seenBefore
            item_status = case_when(
                seenBefore == 0 ~ "new",
                TRUE ~ "old"
            )) %>%
        # Rename 'object' column to 'category'
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
            confidence,
            RT
        )
    return(df)
}

# Main function to process each CSV file
main <- function(csvfile, output_path) {
    message("Processing file: ", csvfile)
    # Read the CSV file into a dataframe and additional variables
    result <- read_file(csvfile)
    # Preprocess the dataframe using the utility function
    df <- preproc_df(result$df, result$vp)
    # Create a subdirectory for the participant if it does not exist
    subdir <- file.path(output_path, sprintf("sub-%s", result$vp))
    if (!dir.exists(subdir)) {
        dir.create(subdir)
        cat("Directory created:", subdir, "\n")
    }
    # Define the output file path and write the preprocessed dataframe as a TSV file
    outfile <- file.path(subdir, sprintf("sub-%s_task-recognition_beh.tsv", result$vp))
    write_tsv(df, outfile, na="n/a")

    # Define output file path for the json sidecar and write to a JSON file
    path_parts <- strsplit(csvfile, split = "/")[[1]]
    csvfile_stripped <- file.path(path_parts[2], path_parts[3])
    sidecar_source <- get_source_json_sidecar(csvfile_stripped)
    sidecar_source_path <- gsub("tsv", "json", outfile)
    write(sidecar_source, file = sidecar_source_path)
}

# List all CSV files in the source directory that match the pattern
csv_files <- list.files(source_path, pattern = ".*phase_4_.*\\.csv$", full.names = TRUE)

# Apply the main function to each CSV file, passing the target path as an argument
result <- mapply(main, csv_files, output_path = target_path, SIMPLIFY = FALSE)

# Write the JSON sidecar data to the specified file
write(sidecar, file = sidecar_path)
