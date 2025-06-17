require(rstan)

get_summary <- function(stanfit) {

    parnames_keys <- c(
        "phi",
        "p_z",
        "mu_beta_rho1",
        "mu_beta_rho2",
        "mu_beta_gamma",
        "tau_u_beta_rho",
        "tau_u_beta_gamma",
        "tau_w_beta_rho",
        "tau_w_beta_gamma",
        "gm_c_beta_rho",
        "gm_c_beta_gamma",
        "R_beta_gamma",
        "u_beta_rho",
        "u_beta_gamma",
        "w_beta_rho",
        "w_beta_gamma"
    )

    parnames <- names(stanfit)

    matching_parnames <- parnames[grep(paste(parnames_keys, collapse = "|"), parnames)]
    

    stanfit_summary <- summary(stanfit, pars = matching_parnames, probs=c())
    summary_text <- capture.output(print(stanfit_summary$summary))

    return(summary_text)
}


