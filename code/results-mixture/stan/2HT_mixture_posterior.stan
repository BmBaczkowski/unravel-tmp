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
    // mixing proportions
    real<lower=0,upper=1> phi;
    // hyper prior on the mean of beta parameters for rho /gamma
    ordered[2] mu_beta_rho[K1];
    vector[K2] mu_beta_gamma; 
    // variation among individuals in beta parameters (with grand mean)
    vector<lower=0>[K1] tau_u_beta_rho;
    vector<lower=0>[K2] tau_u_beta_gamma;
    // Cholesky factors for the correlation of beta parameters (dependency within an individual)
    // cholesky_factor_corr[K1] Lcorr_beta_rho; 
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
transformed parameters {
    // mixing components for rho
    vector[K1] mu_beta_rho1;
    vector[K1] mu_beta_rho2;
    mu_beta_rho1[1] = mu_beta_rho[1][2]; // higher effect
    mu_beta_rho1[2] = mu_beta_rho[2][2]; // higher effect
    mu_beta_rho1[3] = mu_beta_rho[3][1]; // lower effect
    mu_beta_rho1[4] = mu_beta_rho[4][2]; // higher effect
    mu_beta_rho1[5] = mu_beta_rho[5][2]; // higher effect
    mu_beta_rho1[6] = mu_beta_rho[6][2]; // higher effect
    mu_beta_rho2[1] = mu_beta_rho[1][1];
    mu_beta_rho2[2] = mu_beta_rho[2][1];
    mu_beta_rho2[3] = mu_beta_rho[3][2];
    mu_beta_rho2[4] = mu_beta_rho[4][1];
    mu_beta_rho2[5] = mu_beta_rho[5][1];
    mu_beta_rho2[6] = mu_beta_rho[6][1];
    // Correlation matrices for beta parameters (within individuals)
    // corr_matrix[K1] R_beta_rho; 
    corr_matrix[K2] R_beta_gamma;
    // Calculating correlation matrices from Cholesky factors
    // R_beta_rho = multiply_lower_tri_self_transpose(Lcorr_beta_rho);
    R_beta_gamma = multiply_lower_tri_self_transpose(Lcorr_beta_gamma);
    // Adjustments of beta parameters for individuals
    matrix[K1, S_olditems] u_beta_rho;
    matrix[K2, S_newitems] u_beta_gamma;
    for (i in 1:S_olditems){
        u_beta_rho[:, i] = tau_u_beta_rho .* z_u_beta_rho[:, i];
    }
    // u_beta_rho = diag_pre_multiply(tau_u_beta_rho, Lcorr_beta_rho) * z_u_beta_rho;
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
    // rho / gamma in logit space
    vector[N_olditems] rho1;
    vector[N_olditems] rho2;
    vector[N_newitems] gamma;
    for (i in 1:N_olditems){
        rho1[i] = X_design_olditems[i, :] * (
            mu_beta_rho1
            + u_beta_rho[:, sub_id_olditems[i]]
            + w_beta_rho[:, study_id_olditems[i]]
        ) + C_design_olditems[i,1] * gm_c_beta_rho;
    }
    for (i in 1:N_olditems){
        rho2[i] = X_design_olditems[i, :] * (
            mu_beta_rho2
            + u_beta_rho[:, sub_id_olditems[i]]
            + w_beta_rho[:, study_id_olditems[i]]
        ) + C_design_olditems[i,1] * gm_c_beta_rho;
    }
    for (i in 1:N_newitems){
        gamma[i] = X_design_newitems[i, :] * (
            mu_beta_gamma 
            + u_beta_gamma[:, sub_id_newitems[i]]
            + w_beta_gamma[:, study_id_newitems[i]]
        ) + C_design_newitems[i,1] * gm_c_beta_gamma;
    }   
    // rho / gamma in probability space
    vector<lower=0,upper=1>[N_olditems] rho1_hat;
    vector<lower=0,upper=1>[N_olditems] rho2_hat;
    vector<lower=0,upper=1>[N_newitems] gamma_hat;
    rho1_hat = inv_logit(rho1);
    rho2_hat = inv_logit(rho2);
    gamma_hat = inv_logit(gamma);
    // transform rho: rho across all three phases per category to match observations in new items
    // 1
    matrix<lower=0,upper=1>[K1,S_olditems] rho_hat_mat1;
    for (i in 1:N_olditems){
        rho_hat_mat1[cond_id_olditems[i], sub_id_olditems[i]] = rho1_hat[i];
    }
    matrix<lower=0,upper=1>[K2,S_olditems] rho_hat_mat_total1;
    for (i in 1:S_olditems){
        rho_hat_mat_total1[1,i] = prod(rho_hat_mat1[1:3,i]);
        rho_hat_mat_total1[2,i] = prod(rho_hat_mat1[4:6,i]);
    }
    vector<lower=0,upper=1>[N_newitems] rho_hat_newitems1;
    rho_hat_newitems1 = to_vector(rho_hat_mat_total1);
    // 2
    matrix<lower=0,upper=1>[K1,S_olditems] rho_hat_mat2;
    for (i in 1:N_olditems){
        rho_hat_mat2[cond_id_olditems[i], sub_id_olditems[i]] = rho2_hat[i];
    }
    matrix<lower=0,upper=1>[K2,S_olditems] rho_hat_mat_total2;
    for (i in 1:S_olditems){
        rho_hat_mat_total2[1,i] = prod(rho_hat_mat2[1:3,i]);
        rho_hat_mat_total2[2,i] = prod(rho_hat_mat2[4:6,i]);
    }
    vector<lower=0,upper=1>[N_newitems] rho_hat_newitems2;
    rho_hat_newitems2 = to_vector(rho_hat_mat_total2);
    // transform gamma: explode sizewise to match observations in old items 
    matrix[K2, S_newitems] gamma_hat_mat;
    for (i in 1:N_newitems){
        gamma_hat_mat[cond_id_newitems[i], sub_id_newitems[i]] = gamma_hat[i];
    }
    vector<lower=0,upper=1>[N_olditems] gamma_hat_olditems;
    gamma_hat_olditems = to_vector(M * gamma_hat_mat);
    // calculate theta (deterministic)
    vector<lower=0,upper=1>[N_olditems] theta_olditems1;
    vector<lower=0,upper=1>[N_olditems] theta_olditems2;
    vector<lower=0,upper=1>[N_newitems] theta_newitems1;
    vector<lower=0,upper=1>[N_newitems] theta_newitems2;
    theta_olditems1 = rho1_hat + (1-rho1_hat) .* gamma_hat_olditems;
    theta_olditems2 = rho2_hat + (1-rho2_hat) .* gamma_hat_olditems;
    theta_newitems1 = (1-rho_hat_newitems1) .* gamma_hat;
    theta_newitems2 = (1-rho_hat_newitems2) .* gamma_hat;
}

model {
    // mixture proportion
    target += beta_lpdf(phi | 1, 1);
    // intercept (grand mean) -- common for both classes
    target += normal_lpdf(mu_beta_rho[1][:] | -0.5, 1);
    target += normal_lpdf(mu_beta_gamma[1] | -0.8, 1);
    // beta parameters for phase differences -- common for both classes
    for (i in 2:K1){
        target += normal_lpdf(mu_beta_rho[i][:] | 0, 1);
    }
    target += normal_lpdf(mu_beta_gamma[2:] | 0, 1);
    // random effects (participants) -- common across classes
    target += gamma_lpdf(tau_u_beta_rho | 5, 10);
    target += gamma_lpdf(tau_u_beta_gamma | 5, 10);
    // target += lkj_corr_cholesky_lpdf(Lcorr_beta_rho | 2);
    target += lkj_corr_cholesky_lpdf(Lcorr_beta_gamma | 2);
    for (i in 1:K1) {
        target += std_normal_lpdf(z_u_beta_rho[i,:]);
    }
    for (i in 1:K2) {
        target += std_normal_lpdf(z_u_beta_gamma[i,:]);
    }
    // random effects (studies) -- common across classes
    target += uniform_lpdf(tau_w_beta_rho | 0.01, 0.4);
    target += uniform_lpdf(tau_w_beta_gamma | 0.01, 0.4);
    for (i in 1:K1) {
        target += std_normal_lpdf(z_w_beta_rho[i,:]);
    }
    for (i in 1:K2) {
        target += std_normal_lpdf(z_w_beta_gamma[i,:]);
    }
    // fixed effects (semantic category) -- common across classes
    target += normal_lpdf(gm_c_beta_rho | 0, 1);
    target += normal_lpdf(gm_c_beta_gamma | 0, 1);
    // likelihood -- observation function
    // latent mixture at the participant level for old items (rho)
    for (p in 1:S_olditems){
        real log_prob_class_1 = log(phi);
        real log_prob_class_2 = log1m(phi);
        for (i in 1:N_olditems){
            if (sub_id_olditems[i] == p) {
                log_prob_class_1 += binomial_lpmf(
                    y_count_olditems[i] | n_count_olditems[i], theta_olditems1[i]);
                log_prob_class_2 += binomial_lpmf(
                    y_count_olditems[i] | n_count_olditems[i], theta_olditems2[i]);
            }
        }
        for (i in 1:N_newitems){
            if (sub_id_newitems[i] == p) {
                log_prob_class_1 += binomial_lpmf(
                    y_count_newitems[i] | n_count_newitems[i], theta_newitems1[i]
                );
                log_prob_class_2 += binomial_lpmf(
                    y_count_newitems[i] | n_count_newitems[i], theta_newitems2[i]
                );
            }
        }
        target += log_sum_exp(log_prob_class_1, log_prob_class_2);
    }
}

generated quantities {
    // Predicted data
    int y_count_olditems_pred [N_olditems];
    int y_count_newitems_pred [N_newitems];

    // Posterior class assignment
    vector [S_olditems] p_z;
    for (p in 1:S_olditems){
        real log_prob_class_1 = log(phi);
        real log_prob_class_2 = log1m(phi);
        for (i in 1:N_olditems){
            if (sub_id_olditems[i] == p) {
                log_prob_class_1 += binomial_lpmf(
                    y_count_olditems[i] | n_count_olditems[i], theta_olditems1[i]);
                log_prob_class_2 += binomial_lpmf(
                    y_count_olditems[i] | n_count_olditems[i], theta_olditems2[i]);
            }
        }
        for (i in 1:N_newitems){
            if (sub_id_newitems[i] == p) {
                log_prob_class_1 += binomial_lpmf(
                    y_count_newitems[i] | n_count_newitems[i], theta_newitems1[i]
                );
                log_prob_class_2 += binomial_lpmf(
                    y_count_newitems[i] | n_count_newitems[i], theta_newitems2[i]
                );
            }
        }
        p_z[p] = exp(log_prob_class_1 - log_sum_exp(log_prob_class_1, log_prob_class_2));
        int z = bernoulli_rng(p_z[p]);
        for (i in 1:N_olditems){
            if (sub_id_olditems[i] == p) {
                if (z == 1) {
                    y_count_olditems_pred[i] = binomial_rng(n_count_olditems[i], theta_olditems1[i]);
                } else {
                    y_count_olditems_pred[i] = binomial_rng(n_count_olditems[i], theta_olditems2[i]);
                }
            }
        }
        for (i in 1:N_newitems){
            if (sub_id_newitems[i] == p) {
                if (z == 1) {
                    y_count_newitems_pred[i] = binomial_rng(n_count_newitems[i], theta_newitems1[i]);
                } else {
                    y_count_newitems_pred[i] = binomial_rng(n_count_newitems[i], theta_newitems2[i]);
                }
            }
        }
    }
}

