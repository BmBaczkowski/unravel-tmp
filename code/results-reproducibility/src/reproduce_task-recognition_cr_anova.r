#!/usr/local/bin/R

# Reproduce two way repeated measures ANOVA on corrected recognition.
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop("Usage: Rscript script.R <inputfile> <utils_script> <sidecar_script> <outputfile>")
}

# Load necessary libraries
require(dplyr)
require(ez)
require(readr)

inputfile_path <- args[1]
if (grepl("json", inputfile_path)){
    tsv_source_file <- gsub("json", "tsv", inputfile_path)
} else {
    stop("Error: source file name")
}

# Load utility functions from the specified file 
reproduce_anova_func <- local({
  source(args[2], local = TRUE)
  get("reproduce_anova")
})

# Load sidecar
json_sidecar <- local({
  source(args[3], local = TRUE)
  get("sidecar")
})


outputfile_path <- args[4]
if (grepl("json", outputfile_path)){
    json_sidecar_file <- outputfile_path
    txt_target_file <- gsub("json", "txt", outputfile_path)
    rds_target_file <- gsub("json", "rds", outputfile_path)
    tsv_target_file <- gsub("json", "tsv", outputfile_path)
} else {
    stop("Error: target file name")
}

df <- read_tsv(tsv_source_file, 
    col_types = cols(
        study_id = col_factor(),
        participant_id = col_character(),
        condition = col_factor(),
        phase = col_factor(),
        hit = col_double(),
        fa = col_double(),
        CR = col_double()
    ), 
    na = "n/a"
)

result <- reproduce_anova_func(df)

write(json_sidecar, file = json_sidecar_file)
saveRDS(result$aov, file = rds_target_file)
writeLines(result$txt, txt_target_file)
write_tsv(result$df, file = tsv_target_file, na="n/a")

