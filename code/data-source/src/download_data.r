#!/usr/bin/env Rscript

# Retrieve command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Validate the number of arguments
if (length(args) != 2) {
  stop("Usage: Rscript script.R <urls.txt> <path>")
}

# Load packages
require(osfr)

# Assign command line arguments to variables
urls_file <- args[1]
path_to_download <- args[2]

# Create target directory
dir.create(path_to_download)

# Read URLs from the specified file
urls <- readLines(urls_file)

# Retrieve OSF project and list of files
project <- osf_retrieve_node("qpm3t")
files <- osf_ls_files(project)

# Process each URL
for (url in urls) {
  # Retrieve the file associated with the URL
  file_to_download <- files[files$id == url, ]
  
  if (nrow(file_to_download) == 0) {
    stop(sprintf("No file found for URL: %s\n", url))
  }
  
  
  # Download the file
  osf_download(file_to_download, path = path_to_download, conflicts = 'overwrite')
  
  # Define the path of the downloaded file
  source_filename <- file_to_download$name
  source_filepath <- file.path(path_to_download, source_filename)
  
  # Unzip the downloaded file
  if (file.exists(source_filepath)) {
    unzip(source_filepath, exdir = path_to_download)
    cat(sprintf("File '%s' downloaded and unzipped successfully.\n", source_filename))

    # Remove the zip file after extraction
    success <- file.remove(source_filepath)
    
    # Check if the file was successfully deleted
    if (success) {
      cat(sprintf("File '%s' deleted successfully.\n", source_filename))
    } else {
      warning(sprintf("Failed to delete file '%s'.\n", source_filename))
    }
  } else {
    warning(sprintf("Downloaded file '%s' does not exist.\n", source_filename))
  }
}
