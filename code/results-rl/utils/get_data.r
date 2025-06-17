require(dplyr)
require(readr)
require(purrr)

get_data <- function(source_tsv_files) {

    #-------------------------
    # Read data
    #-------------------------

    message("Loading individual tsv files...\n")

    df <- source_tsv_files %>%
    map_dfr(~ read_tsv(., col_types = cols(
        study_id = col_character(),
        participant_id = col_character(),
        trial_id = col_double(),
        # category = col_character(),
        # item_id = col_double(),
        # condition = col_double(),
        shock = col_double(),
        response_csp = col_double(),
        response_csm = col_double()
    ), na="n/a"))

    message("Files loaded and concatenated...\n")


    #-------------------------
    # Transform data
    #-------------------------

    message("Adding unique subject id...\n")

    df <- df %>%
        mutate(
            subject_id = paste(study_id, participant_id, sep="_"),
            subject_id = as.numeric(as.factor(subject_id)),
            study_id = as.numeric(study_id)
        )

    #-------------------------
    # Export to a list 
    #-------------------------

    message("Exporting...\n")


    data <- list()
    data[['N']] <- length(df[['subject_id']])
    data[['subject_id']] <- df[['subject_id']]
    data[['N_subject']] <- length(unique(df[['subject_id']])) # number of subjects
    data[['trial_id']] <- df[['trial_id']]
    data[['N_trial']] <- length(unique(df[['trial_id']]))
    data[['shock']] <- df[['shock']]
    data[['response_csp']] <- df[['response_csp']]
    data[['response_csm']] <- df[['response_csm']]

    out <- list(
        data_list = data, 
        df = df
    )
    return(out)
}
