data {
    // number of data points 
    int<lower=1> N_olditems;
    int<lower=1> N_newitems;
    // data: count 
    int y_count_olditems [N_olditems];
    int y_count_newitems [N_newitems];
    // data: n total responses
    int n_count_olditems [N_olditems];
    int n_count_newitems [N_newitems];
    // number of subjects
    int<lower=1> S_olditems;
    int<lower=1> S_newitems;
    // subject id per observation
    int<lower=1,upper=S_olditems> sub_id_olditems [N_olditems];
    int<lower=1,upper=S_newitems> sub_id_newitems [N_newitems];
    // condition id per observation
    int<lower=1> cond_id_olditems [N_olditems];
    int<lower=1> cond_id_newitems [N_newitems];
    // number of studies
    int<lower=1> St_olditems;
    int<lower=1> St_newitems;
    // study id per observation
    int<lower=1> study_id_olditems [N_olditems];
    int<lower=1> study_id_newitems [N_newitems];
    // number of beta parameters for rho
    int<lower=1> K1;
    // number of beta parameters for gamma
    int<lower=1> K2;
    // design matrix for rho
    matrix<lower=-1,upper=1> [N_olditems,K1] X_design_olditems;
    // design matrix for gamma
    matrix<lower=-1,upper=1> [N_newitems,K2] X_design_newitems; 
    // design matrix for semantic category
    matrix<lower=-1,upper=1> [N_olditems, 1] C_design_olditems;
    matrix<lower=-1,upper=1> [N_newitems, 1] C_design_newitems;  
    // multiplication matrix to explode gamma to rho
    matrix<lower=0,upper=1> [K1,K2] M;
} 
parameters{
    // hyper prior on the mean of beta parameters for rho /gamma
    vector[K1] mu_beta_rho;
    vector[K2] mu_beta_gamma; 
    // variation among individuals in beta parameters (with grand mean)
    vector<lower=0>[K1] tau_u_beta_rho;
    vector<lower=0>[K2] tau_u_beta_gamma;
    // Cholesky factors for the correlation of beta parameters (dependency within an individual)
    cholesky_factor_corr[K1] Lcorr_beta_rho; 
    cholesky_factor_corr[K2] Lcorr_beta_gamma;
    // Normal variates: individual adjustments of beta parameters
    matrix[K1, S_olditems] z_u_beta_rho;  
    matrix[K2, S_newitems] z_u_beta_gamma;
    // variation among studies
    vector<lower=0.01, upper=0.4>[K1] tau_w_beta_rho;
    vector<lower=0.01, upper=0.4>[K2] tau_w_beta_gamma;
    // adjustments
    matrix[K1, St_olditems] z_w_beta_rho;
    matrix[K2, St_newitems] z_w_beta_gamma; 
    // fixed effects of a semantic category (differences in grand mean)
    real gm_c_beta_rho;
    real gm_c_beta_gamma;
}
generated quantities {
    //TRANSFORMED PARAMETERS

    // Correlation matrices for beta parameters (within individuals)
    corr_matrix[K1] R_beta_rho; 
    corr_matrix[K2] R_beta_gamma;
    // Calculating correlation matrices from Cholesky factors
    R_beta_rho = multiply_lower_tri_self_transpose(Lcorr_beta_rho);
    R_beta_gamma = multiply_lower_tri_self_transpose(Lcorr_beta_gamma);
    // Adjustments of beta parameters for individuals
    matrix[K1, S_olditems] u_beta_rho;
    matrix[K2, S_newitems] u_beta_gamma;
    u_beta_rho = diag_pre_multiply(tau_u_beta_rho, Lcorr_beta_rho) * z_u_beta_rho;
    u_beta_gamma = diag_pre_multiply(tau_u_beta_gamma, Lcorr_beta_gamma) * z_u_beta_gamma;
    // Adjustments of beta parameters for studies
    matrix[K1, St_olditems] w_beta_rho;
    matrix[K2, St_newitems] w_beta_gamma;
    for (i in 1:St_olditems){
        w_beta_rho[:, i] = tau_w_beta_rho .* z_w_beta_rho[:, i];
    }
    for (i in 1:St_newitems){
        w_beta_gamma[:, i] = tau_w_beta_gamma .* z_w_beta_gamma[:, i];
    }
    // fixed + random nested (study/participant) effects
    vector[N_olditems] beta_rho;
    vector[N_newitems] beta_gamma;
    for (i in 1:N_olditems){
        beta_rho[i] = X_design_olditems[i, :] * (
            mu_beta_rho 
            + u_beta_rho[:, sub_id_olditems[i]]
            + w_beta_rho[:, study_id_olditems[i]]
        );
    }
    for (i in 1:N_newitems){
        beta_gamma[i] = X_design_newitems[i, :] * (
            mu_beta_gamma 
            + u_beta_gamma[:, sub_id_newitems[i]]
            + w_beta_gamma[:, study_id_newitems[i]]
        );
    }   
    // rho / gamma in logit space
    // y = gm + X*beta + C;
    vector[N_olditems] rho;
    vector[N_newitems] gamma;
    rho = beta_rho + to_vector(C_design_olditems * gm_c_beta_rho);
    gamma = beta_gamma + to_vector(C_design_newitems * gm_c_beta_gamma);
    // rho / gamma in probability space
    vector<lower=0,upper=1>[N_olditems] rho_hat;
    vector<lower=0,upper=1>[N_newitems] gamma_hat;
    rho_hat = inv_logit(rho);
    gamma_hat = inv_logit(gamma);
    // transform gamma: explode sizewise to match observations in old items 
    matrix[K2, S_newitems] gamma_hat_mat;
    for (i in 1:N_newitems){
        gamma_hat_mat[cond_id_newitems[i], sub_id_newitems[i]] = gamma_hat[i];
    }
    vector<lower=0,upper=1>[N_olditems] gamma_hat_olditems;
    gamma_hat_olditems = to_vector(M * gamma_hat_mat);
    // calculate theta (deterministic)
    vector<lower=0,upper=1>[N_olditems] theta_olditems;
    vector<lower=0,upper=1>[N_newitems] theta_newitems;
    theta_olditems = rho_hat + (1-rho_hat) .* gamma_hat_olditems;
    theta_newitems = gamma_hat;

    /* 
    LOGLIK ON HELD-OUT DATA
    */
    vector[N_olditems + N_newitems] log_lik; 
    // Calculate log-likelihood for old observations
    for (i in 1:N_olditems) {
        log_lik[i] = binomial_lpmf(y_count_olditems[i] | n_count_olditems[i], theta_olditems[i]);
    }
    // Calculate log-likelihood for new observations
    for (i in 1:N_newitems) {
        log_lik[N_olditems + i] = binomial_lpmf(y_count_newitems[i] | n_count_newitems[i], theta_newitems[i]);
    }
}


