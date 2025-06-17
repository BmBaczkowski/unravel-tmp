#!/usr/local/bin/R

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
  Rscript script.R 
                  <study_dir_raw1> ... 
                  <study_dir_deriv1> ... 
                  <scr_file1> ... 
                  <rl_file> 
                  <target_file>")
}

#-------------------------
# Read the args
#-------------------------

study_dirs_raw <- file_list[1:4]
study_dirs_derivs <- file_list[5:8]
source_scr_tsv_files <- file_list[(length(file_list) - 6):(length(file_list) - 3)]
source_tsv_file_rl <- file_list[(length(file_list) - 2)]
func_file <- file_list[(length(file_list) - 1)]
target_file <- file_list[length(file_list)]

#-------------------------
# Load 
#-------------------------

source_tsv_files_raw <- unlist(lapply(study_dirs_raw, function(dirname) {
  list.files(
    path = dirname,
    pattern = ".*task-recognition_beh\\.tsv$", 
    recursive = TRUE,
    full.names = TRUE
  )
}))


source_tsv_files_derivs <- unlist(lapply(study_dirs_derivs, function(dirname) {
  list.files(
    path = dirname,
    pattern = ".*task-recognition_desc-reduced_beh\\.tsv$", 
    recursive = TRUE,
    full.names = TRUE
  )
}))

# Create a local environment and source into it
funcs_env <- new.env()
source(func_file, local = funcs_env)

# Extract functions
extract_data_func <- funcs_env$extract_data
extract_conf_func <- funcs_env$extract_confidence


#-------------------------
# Save
#-------------------------

df1 <- extract_data_func(source_tsv_files_derivs, source_tsv_file_rl, source_scr_tsv_files)
df2 <- extract_conf_func(source_tsv_files_raw)

df2 <- df2 %>%
      mutate(
          subject_id = paste(study_id, participant_id, sep="_"),
          subject_id = as.numeric(as.factor(subject_id)),
          study_id = as.numeric(study_id),
          participant_id = as.numeric(participant_id)
    )


df <- left_join(df1, df2, by = c('study_id', 'participant_id')) %>%
    arrange(study_id, participant_id) %>%
    select(-subject_id.x, -subject_id.y, -n_total, -n_high_confidence) %>%
    rename(proportion_high_confidence = proportion)

saveRDS(df, file = target_file)
