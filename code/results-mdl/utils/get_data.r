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
        condition = col_character(),
        first_presentation = col_character(),
        status = col_character(),
        n_old = col_double(),
        n_total = col_double()
    ), na="n/a"))

    message("Files loaded and concatenated...\n")

    #-------------------------
    # Transform data
    #-------------------------

    message("Transforming data...\n")

    df_old <- df %>%
    filter(status == 'old') %>%
    mutate(
        subject_id = paste(study_id, participant_id, sep="_"),
        subject_id = as.numeric(as.factor(subject_id)),
        study_id = as.numeric(study_id),
        category_id = recode(category, "animal" = 1, "tool" = 2),
        condition = recode(condition, "CSm" = 1, "CSp" = 2),
        phase = recode(
            first_presentation, 
            "pre_conditioning" = 1, 
            "conditioning" = 2, 
            "post_conditioning" = 3
        ),
        condition_id = paste(condition, phase, sep="_"),
        condition_id = as.numeric(as.factor(condition_id))
        ) %>%
    select(study_id, subject_id, condition_id, condition, phase, category_id, n_old, n_total) %>%
    arrange(study_id, subject_id, condition_id, condition, phase)

    df_new <- df %>%
    filter(status == 'new') %>%
    mutate(
        subject_id = paste(study_id, participant_id, sep="_"),
        subject_id = as.numeric(as.factor(subject_id)),
        study_id = as.numeric(study_id),
        category_id = recode(category, "animal" = 1, "tool" = 2),
        condition = recode(condition, "CSm" = 1, "CSp" = 2),
        condition_id = condition
    ) %>%
    select(study_id, subject_id, condition_id, condition, category_id, n_old, n_total) %>%
    arrange(study_id, subject_id, condition_id, condition)


    #-------------------------
    # Prepare hypothesis / contrast matrix
    #-------------------------

    message("Preparing matrices...\n")


    # Hypothesis matrix for rho
    # Nested contrast of phase/condition 
    Xh1 <- rbind(
        rhoP1CSm = c(gm=1/6, P21=-1, P32=0, P1CSpCSm=-1, P2CSpCSm=0, P3CSpCSm=0), 
        rhoP2CSm = c(gm=1/6, P21=1, P32=-1, P1CSpCSm=0, P2CSpCSm=-1, P3CSpCSm=0), 
        rhoP3CSm = c(gm=1/6, P21=0, P32=1, P1CSpCSm=0, P2CSpCSm=0, P3CSpCSm=-1), 
        rhoP1CSp = c(gm=1/6, P21=-1, P32=0, P1CSpCSm=1, P2CSpCSm=0, P3CSpCSm=0), 
        rhoP2CSp = c(gm=1/6, P21=1, P32=-1, P1CSpCSm=0, P2CSpCSm=1, P3CSpCSm=0), 
        rhoP3CSp = c(gm=1/6, P21=0, P32=1, P1CSpCSm=0, P2CSpCSm=0, P3CSpCSm=1)
    )


    # Contrast matrix for rho 
    Xc1 <- rbind(
        c(1, -1/3, -1/6, -1/2, 0, 0),
        c(1, 1/6, -1/6, 0, -1/2, 0),
        c(1, 1/6, 1/3, 0, 0, -1/2),
        c(1, -1/3, -1/6, 1/2, 0, 0),
        c(1, 1/6, -1/6, 0, 1/2, 0),
        c(1, 1/6, 1/3, 0, 0, 1/2)
    )

    # Generate design matrix for rho

    condition_id <- df_old %>% 
        pull(condition_id)
    levels <- unique(condition_id)
    n_obs <- length(condition_id)
    n_levels <- length(levels)
    model_matrix <- matrix(0, nrow = n_obs, ncol = n_levels)
    for (i in 1:n_obs) {
        level_index <- which(levels == condition_id[i])
        model_matrix[i, level_index] <- 1
    }

    X_design_olditems <- model_matrix %*% Xc1

    # Hypothesis matrix for gamma
    # sum contrast
    Xh2 <- rbind(
        gammaCSm = c(gm=1/2, CSmCSp=-1), 
        gammaCSp = c(gm=1/2, CSmCSp=1)
    )

    # Contrast matrix for gamma 
    Xc2 <- rbind(
        c(1, -1/2),
        c(1, 1/2)
    )

    condition_id <- df_new %>% 
        pull(condition_id)
    levels <- unique(condition_id)
    n_obs <- length(condition_id)
    n_levels <- length(levels)
    model_matrix <- matrix(0, nrow = n_obs, ncol = n_levels)
    for (i in 1:n_obs) {
        level_index <- which(levels == condition_id[i])
        model_matrix[i, level_index] <- 1
    }

    X_design_newitems <- model_matrix %*% Xc2

   # Multiplication matrix:
   # To explode gamma from [2x1] into [6x1] so that it maps to rho [6x1]

    M <- rbind(
        c(1, 0),
        c(1, 0),
        c(1, 0),
        c(0, 1),
        c(0, 1),
        c(0, 1)
    )

    # Hypothesis matrix for fixed effect of a study
    # sum contrast
    Xh3 <- rbind(
        S1 = c(gm=1/4, S2v1=-1, S3v1=-1, S4v1=-1), 
        S2 = c(gm=1/4, S2v1=1, S3v1=0, S4v1=0), 
        S3 = c(gm=1/4, S2v1=0, S3v1=1, S4v1=0), 
        S4 = c(gm=1/4, S2v1=0, S3v1=0, S4v1=1)
    )


    # Contrast matrix for the fixed effects of study (without intercept)
    Xc3 <- rbind(
        c(-1/4, -1/4, -1/4),
        c(3/4, -1/4, -1/4),
        c(-1/4, 3/4, -1/4),
        c(-1/4, -1/4, 3/4)
    )


    study_id <- df_old %>% 
        pull(study_id)
    levels <- unique(study_id)
    n_obs <- length(study_id)
    n_levels <- length(levels)
    model_matrix <- matrix(0, nrow = n_obs, ncol = n_levels)
    for (i in 1:n_obs) {
        level_index <- which(levels == study_id[i])
        model_matrix[i, level_index] <- 1
    }

    W_design_olditems <- model_matrix %*% Xc3

    study_id <- df_new %>% 
        pull(study_id)
    levels <- unique(study_id)
    n_obs <- length(study_id)
    n_levels <- length(levels)
    model_matrix <- matrix(0, nrow = n_obs, ncol = n_levels)
    for (i in 1:n_obs) {
        level_index <- which(levels == study_id[i])
        model_matrix[i, level_index] <- 1
    }

    W_design_newitems <- model_matrix %*% Xc3

    # Hypothesis matrix for semantic category
    # sum contrast
    Xh4 <- rbind(
        animal = c(gm=1/2, animal=-1), 
        tool = c(gm=1/2, tool=1)
    )

    # Contrast matrix for semantic category (without intercept)
    Xc4 <- rbind(
        c(-1/2),
        c(1/2)
    )

    C_design_olditems <- df_old %>%
        mutate(
            category_id = recode(category_id, `1` = -1/2, `2` = 1/2) 
        ) %>%
        pull(category_id)
    C_design_olditems <- matrix(C_design_olditems, ncol=1)


    C_design_newitems <- df_new %>%
        mutate(
            category_id = recode(category_id, `1` = -1/2, `2` = 1/2) 
        ) %>%
        pull(category_id)
    C_design_newitems <- matrix(C_design_newitems, ncol=1)
    

    #-------------------------
    # Export to a list 
    #-------------------------
    data <- list()
    data[['X_design_olditems']] <- X_design_olditems
    data[['X_design_newitems']] <- X_design_newitems
    data[['W_design_olditems']] <- W_design_olditems
    data[['W_design_newitems']] <- W_design_newitems
    data[['C_design_olditems']] <- C_design_olditems
    data[['C_design_newitems']] <- C_design_newitems
    data[['M']] <- M
    data[['K1']] <- ncol(Xc1) # number of parameters for rho (5)
    data[['K2']] <- ncol(Xc2) # number of parameters for gamma (1)
    data[['K3']] <- ncol(Xc3) # number of parameters for study (3)
    data[['y_count_olditems']] <- df_old[['n_old']] # number of old response to old items
    data[['n_count_olditems']] <- df_old[['n_total']] # number of all responses to old items
    data[['N_olditems']] <- nrow(df_old) # total number of data points
    data[['S_olditems']] <- length(unique(df_old[['subject_id']])) # number of subjects
    data[['St_olditems']] <- length(unique(df_old[['study_id']])) # number of studies
    data[['sub_id_olditems']] <- df_old[['subject_id']] # subject id per observation 
    data[['study_id_olditems']] <- df_old[['study_id']] # study id per observation 
    data[['cond_id_olditems']] <- df_old %>%
        pull(condition_id) # condition id per observation
    data[['y_count_newitems']] <- df_new[['n_old']] # number of old response to new items
    data[['n_count_newitems']] <- df_new[['n_total']] # number of all responses to new items
    data[['N_newitems']] <- nrow(df_new) # total number of data points
    data[['S_newitems']] <- length(unique(df_new[['subject_id']])) # number of subjects
    data[['St_newitems']] <- length(unique(df_new[['study_id']])) # number of studies
    data[['sub_id_newitems']] <- df_new[['subject_id']] # subject id per observation 
    data[['study_id_newitems']] <- df_new[['study_id']] # study id per observation 
    data[['cond_id_newitems']] <- df_new %>%
        pull(condition_id) # condition id per observation

    out <- list(
        data_list = data, 
        df_old = df_old,
        df_new = df_new
    )
    return(out)
}
