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

    // GP
    // feature dimensions
    int<lower=1> D; 
    // input features
    array[S_olditems] vector[D] x; 
} 
transformed data {
  real delta = 1e-9;
}
parameters{
    // hyper prior on the mean of beta parameters for dprime /criterion
    // vector[K1] mu_beta_dprime;
    vector[K2] mu_beta_criterion; 
    // variation among individuals in beta parameters (with grand mean)
    // vector<lower=0>[K1] tau_u_beta_dprime;
    vector<lower=0>[K2] tau_u_beta_criterion;
    // Cholesky factors for the correlation of beta parameters (dependency within an individual)
    // cholesky_factor_corr[K1] Lcorr_beta_dprime; 
    cholesky_factor_corr[K2] Lcorr_beta_criterion;
    // Normal variates: individual adjustments of beta parameters
    // matrix[K1, S_olditems] z_u_beta_dprime;  
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

    // GP
    // cholesky_factor_corr[K1] L_Omega;
    matrix[S_olditems, K1] eta;
    real<lower=0> length_scale;
    real<lower=0> gp_sigma;
     real<lower=0> sigma_f;
    // vector<lower=0>[K1] gp_alpha;
    matrix[S_olditems, K1] u_beta_dprime;
    //-----------
}
transformed parameters {
    // GP -----------------
    matrix[S_olditems, K1] f;
    matrix[S_olditems, S_olditems] K = gp_matern32_cov(x, sigma_f, length_scale);
    matrix[S_olditems, S_olditems] L_K;
    for (n in 1:S_olditems) {
        K[n, n] += delta;
    }
    L_K = cholesky_decompose(K);
    f = L_K * eta; //* diag_pre_multiply(gp_alpha, L_Omega)';
    
    matrix[K1, S_olditems] u_beta_dprime_transposed;
    u_beta_dprime_transposed = transpose(u_beta_dprime);
    // matrix[K1, K1] Omega;
    // Omega = L_Omega * L_Omega';
    //-----------------------


    // Correlation matrices for beta parameters (within individuals)
    // corr_matrix[K1] R_beta_dprime; 
    corr_matrix[K2] R_beta_criterion;
    // Calculating correlation matrices from Cholesky factors
    // R_beta_dprime = multiply_lower_tri_self_transpose(Lcorr_beta_dprime);
    R_beta_criterion = multiply_lower_tri_self_transpose(Lcorr_beta_criterion);
    // Adjustments of beta parameters for individuals
    // matrix[K1, S_olditems] u_beta_dprime;
    matrix[K2, S_newitems] u_beta_criterion;
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
    vector[N_olditems] beta_dprime;
    vector[N_newitems] beta_criterion;
    for (i in 1:N_olditems){
        beta_dprime[i] = X_design_olditems[i, :] * (
            // mu_beta_dprime +
            u_beta_dprime_transposed[:, sub_id_olditems[i]]
            + w_beta_dprime[:, study_id_olditems[i]]
        );
    }
    for (i in 1:N_newitems){
        beta_criterion[i] = X_design_newitems[i, :] * (
            mu_beta_criterion 
            + u_beta_criterion[:, sub_id_newitems[i]]
            + w_beta_criterion[:, study_id_newitems[i]]
        );
    }   

    // y = gm + X*beta + C;
    vector[N_olditems] dprime;
    vector[N_newitems] criterion;
    dprime = beta_dprime + to_vector(C_design_olditems * gm_c_beta_dprime);
    criterion = beta_criterion + to_vector(C_design_newitems * gm_c_beta_criterion);

    // transform criterion: explode sizewise to match observations in old items 
    matrix[K2, S_newitems] criterion_mat;
    for (i in 1:N_newitems){
        criterion_mat[cond_id_newitems[i], sub_id_newitems[i]] = criterion[i];
    }
    vector[N_olditems] criterion_olditems;
    criterion_olditems = to_vector(M * criterion_mat);

    // calculate theta (deterministic) using standard normal cumulative distribution function
    vector<lower=0,upper=1>[N_olditems] theta_olditems;
    vector<lower=0,upper=1>[N_newitems] theta_newitems;
    // Numerical precision issues can make Phi(x) round to exactly 0 or exactly 1 
    // when x is very large or very small.
    real epsilon = 1e-9;
    for (i in 1:N_olditems) {
        theta_olditems[i] = fmin(fmax(
            Phi(dprime[i] - criterion_olditems[i]), epsilon), 1 - epsilon);
    }
    for (i in 1:N_newitems) {
        theta_newitems[i] = fmin(fmax(Phi(-criterion[i]), epsilon), 1 - epsilon);
    }
}

model {
    //-------------------- GP
    // target += lkj_corr_cholesky_lpdf(L_Omega | 2);
    target += std_normal_lpdf(to_vector(eta));
    target += inv_gamma_lpdf(length_scale | 5, 5); 
    target += inv_gamma_lpdf(sigma_f | 5, 5); 
    // target += gamma_lpdf(gp_alpha | 5, 10);
    target += gamma_lpdf(gp_sigma | 5, 10); 
    target += normal_lpdf(to_vector(u_beta_dprime) | to_vector(f), gp_sigma);
    //--------------------


    // intercept (grand mean)
    // target += normal_lpdf(mu_beta_dprime[1] | 1, 0.5);
    target += normal_lpdf(mu_beta_criterion[1] | 0.5, 0.5);
    // remaining beta parameters
    // target += normal_lpdf(mu_beta_dprime[2:] | 0, 1);
    target += normal_lpdf(mu_beta_criterion[2:] | 0, 0.5);
    // random effects (participants)
    // target += gamma_lpdf(tau_u_beta_dprime | 5, 10);
    target += gamma_lpdf(tau_u_beta_criterion | 5, 10);
    // target += lkj_corr_cholesky_lpdf(Lcorr_beta_dprime | 2);
    target += lkj_corr_cholesky_lpdf(Lcorr_beta_criterion | 2);
    // for (i in 1:K1) {
    //     target += std_normal_lpdf(z_u_beta_dprime[i,:]);
    // }
    for (i in 1:K2) {
        target += std_normal_lpdf(z_u_beta_criterion[i,:]);
    }
    // random effects (studies)
    target += uniform_lpdf(tau_w_beta_dprime | 0.01, 0.3);
    target += uniform_lpdf(tau_w_beta_criterion | 0.01, 0.3);
    for (i in 1:K1) {
        target += std_normal_lpdf(z_w_beta_dprime[i,:]);
    }
    for (i in 1:K2) {
        target += std_normal_lpdf(z_w_beta_criterion[i,:]);
    }
    // fixed effects (semantic category)
    target += normal_lpdf(gm_c_beta_dprime | 0, 0.5);
    target += normal_lpdf(gm_c_beta_criterion | 0, 0.5);
    // likelihood -- observation function
    target += binomial_lpmf(y_count_olditems | n_count_olditems, theta_olditems);
    target += binomial_lpmf(y_count_newitems | n_count_newitems, theta_newitems);
}
generated quantities {
    // Predicted data
    int y_count_olditems_pred [N_olditems];
    int y_count_newitems_pred [N_newitems];
    y_count_olditems_pred = binomial_rng(n_count_olditems, theta_olditems);
    y_count_newitems_pred = binomial_rng(n_count_newitems, theta_newitems);
    // Log likelihood of each observation
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

