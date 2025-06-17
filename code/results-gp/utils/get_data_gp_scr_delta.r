require(dplyr)
require(readr)
require(purrr)
require(stringr)

get_data <- function(standata, df_covs) {

    ## Add GP part
    standata[['data_list']][['D']] <- 2
    standata[['data_list']][['x']] <- as.matrix(cbind(
        df_covs[['delta_scr_cda_scaled']], 
        df_covs[['delta_scr_ttp_scaled']]
        ))
    standata[['data_list']][['x_prime']] <- as.matrix(cbind(
        df_covs[['delta_scr_cda']], 
        df_covs[['delta_scr_ttp']]
        ))

    # remove subjects with NA values
    indx <- which(!is.na(standata[['data_list']][['x']][,1]))
    n <- length(indx)

    standata[['data_list']][['x']] <- standata[['data_list']][['x']][indx, ]
    standata[['data_list']][['x_prime']] <- standata[['data_list']][['x_prime']][indx, ]
    
    indx_newitems <- standata[['data_list']][['sub_id_newitems']] %in% indx
    standata[['data_list']][['sub_id_newitems']] <- 
        standata[['data_list']][['sub_id_newitems']][indx_newitems]
    standata[['data_list']][['sub_id_newitems']] <- 
        match(
            standata[['data_list']][['sub_id_newitems']], 
            unique(standata[['data_list']][['sub_id_newitems']])
            )
    standata[['data_list']][['cond_id_newitems']] <- 
        standata[['data_list']][['cond_id_newitems']][indx_newitems]
    standata[['data_list']][['study_id_newitems']] <- 
        standata[['data_list']][['study_id_newitems']][indx_newitems]
    standata[['data_list']][['n_count_newitems']] <- 
        standata[['data_list']][['n_count_newitems']][indx_newitems]
    standata[['data_list']][['y_count_newitems']] <- 
        standata[['data_list']][['y_count_newitems']][indx_newitems]
    k <- 2
    standata[['data_list']][['S_newitems']] <- n
    standata[['data_list']][['N_newitems']] <- k * n
    standata[['data_list']][['X_design_newitems']] <- 
        matrix(standata[['data_list']][['X_design_newitems']][indx_newitems], 
        nrow=n*k, ncol = k) 
    standata[['data_list']][['C_design_newitems']] <- 
        matrix(standata[['data_list']][['C_design_newitems']][indx_newitems], ncol = 1)
    
   
    indx_olditems <- standata[['data_list']][['sub_id_olditems']] %in% indx
    standata[['data_list']][['sub_id_olditems']] <- 
        standata[['data_list']][['sub_id_olditems']][indx_olditems]
    standata[['data_list']][['sub_id_olditems']] <- 
        match(
            standata[['data_list']][['sub_id_olditems']], 
            unique(standata[['data_list']][['sub_id_olditems']])
            )
    standata[['data_list']][['cond_id_olditems']] <- 
        standata[['data_list']][['cond_id_olditems']][indx_olditems]
    standata[['data_list']][['study_id_olditems']] <- 
        standata[['data_list']][['study_id_olditems']][indx_olditems]
    standata[['data_list']][['n_count_olditems']] <- 
        standata[['data_list']][['n_count_olditems']][indx_olditems]
    standata[['data_list']][['y_count_olditems']] <- 
        standata[['data_list']][['y_count_olditems']][indx_olditems]

    k <- 6
    standata[['data_list']][['S_olditems']] <- n
    standata[['data_list']][['N_olditems']] <- k * n
    standata[['data_list']][['X_design_olditems']] <- 
        matrix(standata[['data_list']][['X_design_olditems']][indx_olditems], 
        nrow=n*k, ncol = k) 
    standata[['data_list']][['C_design_olditems']] <- 
        matrix(standata[['data_list']][['C_design_olditems']][indx_olditems], ncol = 1)

    indx_df_old <- standata[['df_old']][['subject_id']] %in% indx
    standata[['df_old']] <- standata[['df_old']][indx_df_old, ]
    
    indx_df_new <- standata[['df_new']][['subject_id']] %in% indx
    standata[['df_new']] <- standata[['df_new']][indx_df_new, ]

    return(standata)
}
