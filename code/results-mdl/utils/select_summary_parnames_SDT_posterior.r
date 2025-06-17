require(rstan)

get_summary <- function(stanfit) {

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
        "R_beta_criterion",
        "u_beta_dprime",
        "u_beta_criterion",
        "w_beta_dprime",
        "w_beta_criterion"
    )

    parnames <- names(stanfit)

    matching_parnames <- parnames[grep(paste(parnames_keys, collapse = "|"), parnames)]
    

    stanfit_summary <- summary(stanfit, pars = matching_parnames, probs=c())
    summary_text <- capture.output(print(stanfit_summary$summary))

    return(summary_text)
}


