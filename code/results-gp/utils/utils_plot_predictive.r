
plot_func <- function(stanfit, data, target_file) {
    df_old <- data[['df_old']]
    df_new <- data[['df_new']]

    condition_id_olditems <- df_old %>%
        pull(condition_id)
    study_id_olditems <- df_old %>%
        pull(study_id)
    condition_id_newitems <- df_new %>%
        pull(condition_id)
    study_id_newitems <- df_new %>%
        pull(study_id)

    parnames <- names(stanfit)
    ypred_old_keys <- "y_count_olditems_pred"
    ypred_new_keys <- "y_count_newitems_pred"
    ypred_pars_old <- parnames[grep(paste(ypred_old_keys, collapse = "|"), parnames)]
    ypred_pars_new <- parnames[grep(paste(ypred_new_keys, collapse = "|"), parnames)]

    samples <- as.matrix(stanfit)

    # old items 
    n_old <- df_old %>%
        pull(n_old)
    n_total <- df_old %>%
        pull(n_total)

    var_names <- c(
        "CSm_preconditioning",
        "CSm_conditioning",
        "CSm_postconditioning",
        "CSp_preconditioning",
        "CSp_conditioning",
        "CSp_postconditioning"
    )

    pdf(file = target_file, width = 7, height = 5)  # Width and height are in inches
    for (i in unique(condition_id_olditems)) {
        indx <- which(condition_id_olditems == i)
        var_name <- var_names[i]
        study_id_ <- study_id_olditems[indx]

        y_total <- n_total[indx]
        y_count <- n_old[indx]
        y <- y_count / y_total
        y_count_pred <- samples[, ypred_pars_old[indx]]
        ypred <- t(apply(y_count_pred, 1, function(row) row / y_total))
        
        outplot <- ppc_stat_grouped(
            y, 
            ypred, 
            group = study_id_,
            stat = 'mean',
            bins = 50
            ) + labs(title=var_name)
        print(outplot)
        outplot <- ppc_stat(
            y, 
            ypred, 
            stat = 'mean',
            bins = 50
            ) + labs(title=var_name)
        print(outplot)
    }

    # new items 
    n_old <- df_new %>%
        pull(n_old)
    n_total <- df_new %>%
        pull(n_total)

    var_names <- c(
        "CSm_new",
        "CSp_new"
    )

    for (i in unique(condition_id_newitems)) {
        indx <- which(condition_id_newitems == i)
        var_name <- var_names[i]
        study_id_ <- study_id_newitems[indx]

        y_total <- n_total[indx]
        y_count <- n_old[indx]
        y <- y_count / y_total
        y_count_pred <- samples[, ypred_pars_new[indx]]
        ypred <- t(apply(y_count_pred, 1, function(row) row / y_total))

        outplot <- ppc_stat_grouped(
            y, 
            ypred, 
            group = study_id_,
            stat = 'mean',
            bins = 50
            ) + labs(title=var_name)
        print(outplot)
        outplot <- ppc_stat(
            y, 
            ypred, 
            stat = 'mean',
            bins = 50
            ) + labs(title=var_name)
        print(outplot)
    }
    dev.off()
}
