#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop("Usage: Rscript script.R <sidecar_source_file> <sidecar_target_file>")
}

# Load json sidecar string
source(args[1])

# Define json sidecar path
sidecar_path <- args[2]

# Write the JSON data to the file
write(sidecar, file = sidecar_path)
