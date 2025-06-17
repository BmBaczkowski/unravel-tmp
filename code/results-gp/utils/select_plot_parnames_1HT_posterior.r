get_parnames <- function(stanfit) {

    parnames_keys <- c(
        # "mu_beta_rho",
        "mu_beta_gamma",
        # "tau_u_beta_rho",
        "tau_u_beta_gamma",
        "tau_w_beta_rho",
        "tau_w_beta_gamma",
        "gm_c_beta_rho",
        "gm_c_beta_gamma",
        # "R_beta_rho",
        "R_beta_gamma",
        "length_scale",
        "gp_sigma",
        # "gp_alpha",
        "sigma_f"
        # "Omega"
    )

    parnames <- names(stanfit)

    matching_parnames <- parnames[grep(paste(parnames_keys, collapse = "|"), parnames)]
    # remove patterns like [1,1] [2,2]
    matching_parnames <- matching_parnames[!grepl("\\[([0-9]),\\1\\]", matching_parnames)]

    return(matching_parnames)
}
