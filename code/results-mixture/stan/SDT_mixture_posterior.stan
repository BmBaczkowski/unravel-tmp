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
    // number of beta parameters for dprime
    int<lower=1> K1;
    // number of beta parameters for criterion
    int<lower=1> K2;
    // design matrix for dprime
    matrix<lower=-1,upper=1> [N_olditems,K1] X_design_olditems;
    // design matrix for criterion
    matrix<lower=-1,upper=1> [N_newitems,K2] X_design_newitems; 
    // design matrix for semantic category
    matrix<lower=-1,upper=1> [N_olditems, 1] C_design_olditems;
    matrix<lower=-1,upper=1> [N_newitems, 1] C_design_newitems;  
    // multiplication matrix to explode criterion to dprime
    matrix<lower=0,upper=1> [K1,K2] M;
} 
parameters{
    // mixing proportions
    real<lower=0,upper=1> phi;
    // hyper prior on the mean of beta parameters for dprime /criterion
    ordered[2] mu_beta_dprime[K1];
    vector[K2] mu_beta_criterion; 
    // variation among individuals in beta parameters (with grand mean)
    vector<lower=0>[K1] tau_u_beta_dprime;
    vector<lower=0>[K2] tau_u_beta_criterion;
    // Cholesky factors for the correlation of beta parameters (dependency within an individual)
    // cholesky_factor_corr[K1] Lcorr_beta_dprime; 
    cholesky_factor_corr[K2] Lcorr_beta_criterion;
    // Normal variates: individual adjustments of beta parameters
    matrix[K1, S_olditems] z_u_beta_dprime;  
    matrix[K2, S_newitems] z_u_beta_criterion;
    // variation among studies
    vector<lower=0.01, upper=0.3>[K1] tau_w_beta_dprime;
    vector<lower=0.01, upper=0.3>[K2] tau_w_beta_criterion;
    // adjustments
    matrix[K1, St_olditems] z_w_beta_dprime;
    matrix[K2, St_newitems] z_w_beta_criterion; 
    // fixed effects of a semantic category (differences in grand mean)
    real gm_c_beta_dprime;
    real gm_c_beta_criterion;
}
transformed parameters {
    // mixing components for dprime
    vector[K1] mu_beta_dprime1;
    vector[K1] mu_beta_dprime2;
    mu_beta_dprime1[1] = mu_beta_dprime[1][2]; // higher effect
    mu_beta_dprime1[2] = mu_beta_dprime[2][2]; // higher effect
    mu_beta_dprime1[3] = mu_beta_dprime[3][1]; // lower effect
    mu_beta_dprime1[4] = mu_beta_dprime[4][2]; // higher effect
    mu_beta_dprime1[5] = mu_beta_dprime[5][2]; // higher effect
    mu_beta_dprime1[6] = mu_beta_dprime[6][2]; // higher effect
    mu_beta_dprime2[1] = mu_beta_dprime[1][1];
    mu_beta_dprime2[2] = mu_beta_dprime[2][1];
    mu_beta_dprime2[3] = mu_beta_dprime[3][2];
    mu_beta_dprime2[4] = mu_beta_dprime[4][1];
    mu_beta_dprime2[5] = mu_beta_dprime[5][1];
    mu_beta_dprime2[6] = mu_beta_dprime[6][1];
    // Correlation matrices for beta parameters (within individuals)
    // corr_matrix[K1] R_beta_dprime; 
    corr_matrix[K2] R_beta_criterion;
    // Calculating correlation matrices from Cholesky factors
    // R_beta_dprime = multiply_lower_tri_self_transpose(Lcorr_beta_dprime);
    R_beta_criterion = multiply_lower_tri_self_transpose(Lcorr_beta_criterion);
    // Adjustments of beta parameters for individuals
    matrix[K1, S_olditems] u_beta_dprime;
    matrix[K2, S_newitems] u_beta_criterion;
    for (i in 1:S_olditems){
        u_beta_dprime[:, i] = tau_u_beta_dprime .* z_u_beta_dprime[:, i];
    }
    // u_beta_dprime = diag_pre_multiply(tau_u_beta_dprime, Lcorr_beta_dprime) * z_u_beta_dprime;
    u_beta_criterion = diag_pre_multiply(tau_u_beta_criterion, Lcorr_beta_criterion) * z_u_beta_criterion;
    // Adjustments of beta parameters for studies
    matrix[K1, St_olditems] w_beta_dprime;
    matrix[K2, St_newitems] w_beta_criterion;
    for (i in 1:St_olditems){
        w_beta_dprime[:, i] = tau_w_beta_dprime .* z_w_beta_dprime[:, i];
    }
    for (i in 1:St_newitems){
        w_beta_criterion[:, i] = tau_w_beta_criterion .* z_w_beta_criterion[:, i];
    }
    // fixed + random nested (study/participant) effects
    // dprime / criterion in logit space
    vector[N_olditems] dprime1;
    vector[N_olditems] dprime2;
    vector[N_newitems] criterion;
    for (i in 1:N_olditems){
        dprime1[i] = X_design_olditems[i, :] * (
            mu_beta_dprime1
            + u_beta_dprime[:, sub_id_olditems[i]]
            + w_beta_dprime[:, study_id_olditems[i]]
        ) + C_design_olditems[i,1] * gm_c_beta_dprime;
    }
    for (i in 1:N_olditems){
        dprime2[i] = X_design_olditems[i, :] * (
            mu_beta_dprime2
            + u_beta_dprime[:, sub_id_olditems[i]]
            + w_beta_dprime[:, study_id_olditems[i]]
        ) + C_design_olditems[i,1] * gm_c_beta_dprime;
    }
    for (i in 1:N_newitems){
        criterion[i] = X_design_newitems[i, :] * (
            mu_beta_criterion 
            + u_beta_criterion[:, sub_id_newitems[i]]
            + w_beta_criterion[:, study_id_newitems[i]]
        ) + C_design_newitems[i,1] * gm_c_beta_criterion;
    }   

    // transform criterion: explode sizewise to match observations in old items 
    matrix[K2, S_newitems] criterion_mat;
    for (i in 1:N_newitems){
        criterion_mat[cond_id_newitems[i], sub_id_newitems[i]] = criterion[i];
    }
    vector[N_olditems] criterion_olditems;
    criterion_olditems = to_vector(M * criterion_mat);

    // calculate theta (deterministic) using standard normal cumulative distribution function
    vector<lower=0,upper=1>[N_olditems] theta_olditems1;
    vector<lower=0,upper=1>[N_olditems] theta_olditems2;
    vector<lower=0,upper=1>[N_newitems] theta_newitems;
    // Numerical precision issues can make Phi(x) round to exactly 0 or exactly 1 
    // when x is very large or very small.
    real epsilon = 1e-9;
    for (i in 1:N_olditems) {
        theta_olditems1[i] = fmin(fmax(
            Phi(dprime1[i] - criterion_olditems[i]), epsilon), 1 - epsilon);
    }
    for (i in 1:N_olditems) {
        theta_olditems2[i] = fmin(fmax(
            Phi(dprime2[i] - criterion_olditems[i]), epsilon), 1 - epsilon);
    }
    for (i in 1:N_newitems) {
        theta_newitems[i] = fmin(fmax(Phi(-criterion[i]), epsilon), 1 - epsilon);
    }
}

model {
    // mixture proportion
    target += beta_lpdf(phi | 1, 1);
    // intercept (grand mean) -- common for both classes
    target += normal_lpdf(mu_beta_dprime[1][:] | 1, 0.5);
    target += normal_lpdf(mu_beta_criterion[1] | 0.5, 0.5);
    // beta parameters for phase differences -- common for both classes
    for (i in 2:K1){
        target += normal_lpdf(mu_beta_dprime[i][:] | 0, 0.5);
    }
    target += normal_lpdf(mu_beta_criterion[2:] | 0, 0.5);
    // random effects (participants) -- common across classes
    target += gamma_lpdf(tau_u_beta_dprime | 5, 10);
    target += gamma_lpdf(tau_u_beta_criterion | 5, 10);
    // target += lkj_corr_cholesky_lpdf(Lcorr_beta_dprime | 2);
    target += lkj_corr_cholesky_lpdf(Lcorr_beta_criterion | 2);
    for (i in 1:K1) {
        target += std_normal_lpdf(z_u_beta_dprime[i,:]);
    }
    for (i in 1:K2) {
        target += std_normal_lpdf(z_u_beta_criterion[i,:]);
    }
    // random effects (studies) -- common across classes
    target += uniform_lpdf(tau_w_beta_dprime | 0.01, 0.3);
    target += uniform_lpdf(tau_w_beta_criterion | 0.01, 0.3);
    for (i in 1:K1) {
        target += std_normal_lpdf(z_w_beta_dprime[i,:]);
    }
    for (i in 1:K2) {
        target += std_normal_lpdf(z_w_beta_criterion[i,:]);
    }
    // fixed effects (semantic category) -- common across classes
    target += normal_lpdf(gm_c_beta_dprime | 0, 0.5);
    target += normal_lpdf(gm_c_beta_criterion | 0, 0.5);
    // likelihood -- observation function
    // latent mixture at the participant level for old items (dprime)
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
        target += log_sum_exp(log_prob_class_1, log_prob_class_2);
    }
    target += binomial_lpmf(y_count_newitems | n_count_newitems, theta_newitems);
}

generated quantities {
    // Predicted data
    int y_count_olditems_pred [N_olditems];
    int y_count_newitems_pred [N_newitems];
    y_count_newitems_pred = binomial_rng(n_count_newitems, theta_newitems);

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
    }
}
