get_parnames <- function(stanfit) {

    parnames_keys <- c(
        "mu_beta_dprime",
        "mu_beta_criterion",
        "tau_u_beta_dprime",
        "tau_u_beta_criterion",
        "tau_w_beta_dprime",
        "tau_w_beta_criterion",
        "gm_c_beta_dprime",
        "gm_c_beta_criterion",
        "R_beta_dprime",
        "R_beta_criterion"
    )

    parnames <- names(stanfit)

    matching_parnames <- parnames[grep(paste(parnames_keys, collapse = "|"), parnames)]
    # remove patterns like [1,1] [2,2]
    matching_parnames <- matching_parnames[!grepl("\\[([0-9]),\\1\\]", matching_parnames)]

    return(matching_parnames)
}
