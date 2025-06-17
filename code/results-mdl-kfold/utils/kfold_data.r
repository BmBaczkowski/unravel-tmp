require(dplyr)
require(readr)
require(purrr)

get_data <- function(source_data_file) {

    # read the data
    data_source <- readRDS(source_data_file)

    # get study and subject ids
    id_df_olditems <- tibble(
        study_id = data_source$data_list$study_id_olditems, 
        sub_id = data_source$data_list$sub_id_olditems
    )
    id_df_newitems <- tibble(
        study_id = data_source$data_list$study_id_newitems, 
        sub_id = data_source$data_list$sub_id_newitems
    )

    # keep only unique rows
    id_df_unique <- id_df_olditems %>%
        distinct()

    set.seed(1234)
    kfold <- id_df_unique %>%
        group_by(study_id) %>%
        mutate(fold = sample(rep(1:5, length.out = n()))) %>%
        ungroup()

    dat <- list()
    for (i in 1:5){
        test_id <- kfold %>%
            filter(fold == i) %>%
            select(study_id, sub_id)
    
        train_id <- anti_join(
            id_df_unique, 
            test_id, 
            by = c("study_id", "sub_id"))


        indx_train_olditems <- which(id_df_olditems$sub_id %in% train_id$sub_id)
        indx_test_olditems <- which(id_df_olditems$sub_id %in% test_id$sub_id)
        indx_train_newitems <- which(id_df_newitems$sub_id %in% train_id$sub_id)
        indx_test_newitems <- which(id_df_newitems$sub_id %in% test_id$sub_id)
        
        data_target <- list()
        # Train
        data_target[['data_train']] <- list()
        data_target[['data_train']][['K1']] <- data_source[['data_list']][['K1']]
        data_target[['data_train']][['K2']] <- data_source[['data_list']][['K2']]
        data_target[['data_train']][['K3']] <- data_source[['data_list']][['K3']]
        data_target[['data_train']][['M']] <- data_source[['data_list']][['M']]
        data_target[['data_train']][['St_olditems']] <- data_source[['data_list']][['St_olditems']]
        data_target[['data_train']][['St_newitems']] <- data_source[['data_list']][['St_newitems']]
        data_target[['data_train']][['X_design_olditems']] <- 
            data_source[['data_list']][['X_design_olditems']][indx_train_olditems,]
        data_target[['data_train']][['X_design_newitems']] <- 
            data_source[['data_list']][['X_design_newitems']][indx_train_newitems,]
        data_target[['data_train']][['W_design_olditems']] <- 
            data_source[['data_list']][['W_design_olditems']][indx_train_olditems,]
        data_target[['data_train']][['W_design_newitems']] <- 
            data_source[['data_list']][['W_design_newitems']][indx_train_newitems,]
        data_target[['data_train']][['C_design_olditems']] <- 
            data_source[['data_list']][['C_design_olditems']][indx_train_olditems,, drop=FALSE]
        data_target[['data_train']][['C_design_newitems']] <- 
            data_source[['data_list']][['C_design_newitems']][indx_train_newitems,, drop=FALSE]
        data_target[['data_train']][['sub_id_olditems']] <- 
            data_source[['data_list']][['sub_id_olditems']][indx_train_olditems]
        data_target[['data_train']][['sub_id_olditems']] <- match(
            data_target[['data_train']][['sub_id_olditems']], 
            unique(data_target[['data_train']][['sub_id_olditems']])
        )
        data_target[['data_train']][['sub_id_newitems']] <- 
            data_source[['data_list']][['sub_id_newitems']][indx_train_newitems]
        data_target[['data_train']][['sub_id_newitems']] <- match(
            data_target[['data_train']][['sub_id_newitems']], 
            unique(data_target[['data_train']][['sub_id_newitems']])
        )
        data_target[['data_train']][['study_id_olditems']] <- 
            data_source[['data_list']][['study_id_olditems']][indx_train_olditems]
        data_target[['data_train']][['study_id_newitems']] <- 
            data_source[['data_list']][['study_id_newitems']][indx_train_newitems]
        data_target[['data_train']][['cond_id_olditems']] <- 
            data_source[['data_list']][['cond_id_olditems']][indx_train_olditems]
        data_target[['data_train']][['cond_id_newitems']] <- 
            data_source[['data_list']][['cond_id_newitems']][indx_train_newitems]
        data_target[['data_train']][['y_count_olditems']] <- 
            data_source[['data_list']][['y_count_olditems']][indx_train_olditems]
        data_target[['data_train']][['y_count_newitems']] <- 
            data_source[['data_list']][['y_count_newitems']][indx_train_newitems]
        data_target[['data_train']][['n_count_olditems']] <- 
            data_source[['data_list']][['n_count_olditems']][indx_train_olditems]
        data_target[['data_train']][['n_count_newitems']] <- 
            data_source[['data_list']][['n_count_newitems']][indx_train_newitems]
        data_target[['data_train']][['N_olditems']] <- length(indx_train_olditems)
        data_target[['data_train']][['N_newitems']] <- length(indx_train_newitems)
        data_target[['data_train']][['S_olditems']] <- length(
            unique(data_target[['data_train']][['sub_id_olditems']])
        )
        data_target[['data_train']][['S_newitems']] <- length(
            unique(data_target[['data_train']][['sub_id_newitems']])
        )

        # Test
        data_target[['data_test']] <- list()
        data_target[['data_test']] <- list()
        data_target[['data_test']][['K1']] <- data_source[['data_list']][['K1']]
        data_target[['data_test']][['K2']] <- data_source[['data_list']][['K2']]
        data_target[['data_test']][['K3']] <- data_source[['data_list']][['K3']]
        data_target[['data_test']][['M']] <- data_source[['data_list']][['M']]
        data_target[['data_test']][['St_olditems']] <- data_source[['data_list']][['St_olditems']]
        data_target[['data_test']][['St_newitems']] <- data_source[['data_list']][['St_newitems']]
        data_target[['data_test']][['X_design_olditems']] <- 
            data_source[['data_list']][['X_design_olditems']][indx_test_olditems,]
        data_target[['data_test']][['X_design_newitems']] <- 
            data_source[['data_list']][['X_design_newitems']][indx_test_newitems,]
        data_target[['data_test']][['W_design_olditems']] <- 
            data_source[['data_list']][['W_design_olditems']][indx_test_olditems,]
        data_target[['data_test']][['W_design_newitems']] <- 
            data_source[['data_list']][['W_design_newitems']][indx_test_newitems,]
        data_target[['data_test']][['C_design_olditems']] <- 
            data_source[['data_list']][['C_design_olditems']][indx_test_olditems,, drop=FALSE]
        data_target[['data_test']][['C_design_newitems']] <- 
            data_source[['data_list']][['C_design_newitems']][indx_test_newitems,, drop=FALSE]
        data_target[['data_test']][['sub_id_olditems']] <- 
            data_source[['data_list']][['sub_id_olditems']][indx_test_olditems]
        data_target[['data_test']][['sub_id_olditems']] <- match(
            data_target[['data_test']][['sub_id_olditems']], 
            unique(data_target[['data_test']][['sub_id_olditems']])
        )
        data_target[['data_test']][['sub_id_newitems']] <- 
            data_source[['data_list']][['sub_id_newitems']][indx_test_newitems]
        data_target[['data_test']][['sub_id_newitems']] <- match(
            data_target[['data_test']][['sub_id_newitems']], 
            unique(data_target[['data_test']][['sub_id_newitems']])
        )
        data_target[['data_test']][['study_id_olditems']] <- 
            data_source[['data_list']][['study_id_olditems']][indx_test_olditems]
        data_target[['data_test']][['study_id_newitems']] <- 
            data_source[['data_list']][['study_id_newitems']][indx_test_newitems]
        data_target[['data_test']][['cond_id_olditems']] <- 
            data_source[['data_list']][['cond_id_olditems']][indx_test_olditems]
        data_target[['data_test']][['cond_id_newitems']] <- 
            data_source[['data_list']][['cond_id_newitems']][indx_test_newitems]
        data_target[['data_test']][['y_count_olditems']] <- 
            data_source[['data_list']][['y_count_olditems']][indx_test_olditems]
        data_target[['data_test']][['y_count_newitems']] <- 
            data_source[['data_list']][['y_count_newitems']][indx_test_newitems]
        data_target[['data_test']][['n_count_olditems']] <- 
            data_source[['data_list']][['n_count_olditems']][indx_test_olditems]
        data_target[['data_test']][['n_count_newitems']] <- 
            data_source[['data_list']][['n_count_newitems']][indx_test_newitems]
        data_target[['data_test']][['N_olditems']] <- length(indx_test_olditems)
        data_target[['data_test']][['N_newitems']] <- length(indx_test_newitems)
        data_target[['data_test']][['S_olditems']] <- length(
            unique(data_target[['data_test']][['sub_id_olditems']])
        )
        data_target[['data_test']][['S_newitems']] <- length(
            unique(data_target[['data_test']][['sub_id_newitems']])
        )
    
        dat[[i]] <- data_target
    }

    return(dat)
}
