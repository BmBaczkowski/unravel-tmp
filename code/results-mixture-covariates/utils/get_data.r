require(dplyr)
require(readr)
require(purrr)
require(stringr)

extract_data <- function(source_tsv_files_recon, source_tsv_file_rl, source_tsv_files_scr) {


    #-------------------------
    # Read data
    #-------------------------

    message("Loading individual tsv files...\n")

    # Rescorla-Wagner learning rate
    df_rl <- read_tsv(source_tsv_file_rl)
    df_rl <- df_rl %>%
        mutate(
            participant_id = as.integer(participant_id),
            alpha_scaled = round(as.numeric(scale(alpha)), 2)
    )



    df <- source_tsv_files_recon %>%
        map_dfr(~ read_tsv(., col_types = cols(
            study_id = col_double(),
            participant_id = col_double(),
            condition = col_character(),
            category = col_character(),
            first_presentation = col_character(),
            status = col_character(),
            n_old = col_double(),
            n_total = col_double()
        ), na="n/a")) %>%
        select(-first_presentation, -status, -n_old, -n_total) %>%
        filter(condition == "CSp") %>%
        mutate(
            participant_id = str_pad(participant_id, width = 3, pad = "0"),
            subject_id = paste(study_id, participant_id, sep="_"),
            subject_id = as.numeric(as.factor(subject_id)),
            participant_id = as.numeric(participant_id)
        ) %>%
        group_by(subject_id) %>%
        slice(n()) %>%
        ungroup()


    df <- inner_join(df, df_rl, by = c('study_id', 'participant_id'))

    # check if matching participants worked
    if (!identical(df$subject_id.x, df$subject_id.y)) {
        print("Not")
        stop()
    }


    # SCR
    df_scr <- source_tsv_files_scr %>%
        map_dfr(~ {
            # Extract the study number from the file name
            study_id <- str_extract(basename(.), "\\d+")

            # Read the TSV file
            data <- read_tsv(., col_types = cols(
            subj = col_double(),
            wasConditioned = col_double(),
            mean_CDA_SCR = col_double(),
            mean_TTP_AmpSum = col_double()
            ), na = "n/a")
            
            # Add the extracted study number as a new column
            data <- data %>% mutate(
                study_id = str_pad(study_id, width = 2, pad = "0")
                )
            
            return(data)
        }) %>%
        rename(participant_id = subj) %>%
        arrange(study_id, participant_id) %>%
        mutate(
            participant_id = str_pad(participant_id, width = 3, pad = "0"),
            subject_id = paste(study_id, participant_id, sep="_"),
            subject_id = as.numeric(as.factor(subject_id))
        ) 
        
    df_scr_ <- df_scr %>%
        group_by(subject_id) %>%
        summarise(
            avg_scr_cda = round(mean(mean_CDA_SCR), 2),
            avg_scr_ttp = round(mean(mean_TTP_AmpSum), 2),
            delta_scr_cda = mean_CDA_SCR[wasConditioned == 1] - mean_CDA_SCR[wasConditioned == 0],
            delta_scr_cda = round(delta_scr_cda, 2),
            delta_scr_ttp = mean_TTP_AmpSum[wasConditioned == 1] - mean_TTP_AmpSum[wasConditioned == 0],
            delta_scr_ttp = round(delta_scr_ttp, 2),
            .groups = 'drop'
        ) %>%
        mutate(
            avg_scr_cda_scaled = round(as.numeric(scale(avg_scr_cda)), 2),
            avg_scr_ttp_scaled = round(as.numeric(scale(avg_scr_ttp)), 2),
            delta_scr_cda_scaled = round(as.numeric(scale(delta_scr_cda)), 2),
            delta_scr_ttp_scaled = round(as.numeric(scale(delta_scr_ttp)), 2)
        )

    df_scr <- df_scr %>%
        left_join(df_scr_, by = "subject_id") %>%
        select(
            study_id, 
            participant_id, 
            avg_scr_cda, 
            avg_scr_cda_scaled, 
            avg_scr_ttp, 
            avg_scr_ttp_scaled, 
            delta_scr_cda, 
            delta_scr_cda_scaled, 
            delta_scr_ttp,
            delta_scr_ttp_scaled 
        ) %>%
        distinct() %>%
        mutate(
            study_id = as.numeric(study_id),
            participant_id = as.numeric(participant_id)
        )


    
    # join the two dfs
    df <- left_join(df, df_scr, by = c('study_id', 'participant_id')) %>%
        arrange(study_id, participant_id)
    
    # df_missing <- df %>%
    #     filter(is.na(avg_scr_cda))

    return(df)
}



extract_confidence <- function(source_tsv_files) {

    source_tsv_files1 <- str_subset(source_tsv_files, "study-01")
    source_tsv_files234 <- source_tsv_files[!str_detect(source_tsv_files, "study-01")]

    message("Processing individual tsv files...\n")

    df1 <- source_tsv_files1 %>%
        map_dfr(~ {
            # Extract study_id from the file name using a regex
            study_id <- str_extract(., "study-(\\d+)") %>% 
                str_replace("study-", "")  # Remove the "study-" part

            # Read the TSV file and add the study_id as a new column
            read_tsv(., col_types = cols(
            participant_id = col_character(),
            trial_id = col_double(),
            condition = col_character(),
            category = col_character(),
            item_id = col_double(),
            item_first_presentation = col_character(),
            item_status = col_character(),
            response = col_character(),
            RT_response = col_double(),
            confidence = col_character(),
            RT_confidence = col_double()
        ), na="n/a") %>%
        mutate(study_id = study_id)
        }) %>%
        group_by(study_id, participant_id) %>%
        summarize(
            n_high_confidence = sum(str_detect(confidence, "very_sure"), na.rm=T), # Count high confidence 
            n_total = sum(!is.na(response)), # Count total responses
            proportion = round(n_high_confidence / n_total, 2),
            .groups = 'drop' # Drop grouping structure
        ) %>%
        select(
            study_id,
            participant_id,
            n_high_confidence,
            n_total,
            proportion
        )

    df2 <- source_tsv_files234 %>%
        map_dfr(~ {
            # Extract study_id from the file name using a regex
            study_id <- str_extract(., "study-(\\d+)") %>% 
                str_replace("study-", "")  # Remove the "study-" part

            # Read the TSV file and add the study_id as a new column
            read_tsv(., col_types = cols(
            participant_id = col_character(),
            trial_id = col_double(),
            condition = col_character(),
            category = col_character(),
            item_id = col_double(),
            item_first_presentation = col_character(),
            item_status = col_character(),
            response = col_character(),
            RT = col_double(),
            confidence = col_character()
        ), na="n/a") %>%
        mutate(study_id = study_id)
        }) %>%
        group_by(study_id, participant_id) %>%
        summarize(
            n_high_confidence = sum(str_detect(confidence, "definitely"), na.rm=T), # Count high confidence 
            n_total = sum(!is.na(response)), # Count total responses
            proportion = round(n_high_confidence / n_total, 2),
            .groups = 'drop' # Drop grouping structure
        ) %>%
        select(
            study_id,
            participant_id,
            n_high_confidence,
            n_total,
            proportion
        )

    df <- bind_rows(df1, df2)

    return(df)

}