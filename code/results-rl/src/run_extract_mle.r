args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop("Usage: 
  Rscript script.R  <stanfit>
                    <data>
                    <func_file>
                    <output_file>")
}

require(dplyr)
require(readr)

#-------------------------
# Read the args
#-------------------------

stanfit_file <- args[1]
data_file <- args[2]
func_file <- args[3]
output_file <- args[4]

#-------------------------
# Load 
#-------------------------

data <- readRDS(data_file)
stanfit <- readRDS(stanfit_file)
extract_mle <- local({
  source(func_file, local = TRUE)
  get("extract_mle")
})

#-------------------------
# RUN
#-------------------------

df_pred <- extract_mle(stanfit)
df <- data$df %>%
    select(study_id, participant_id, subject_id) %>%
    unique()

df <- bind_cols(df, df_pred)

#-------------------------
# Save
#-------------------------

write_tsv(df, output_file)


