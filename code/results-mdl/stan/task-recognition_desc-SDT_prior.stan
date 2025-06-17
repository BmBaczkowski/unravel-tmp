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
    // number of beta parameters for criterion
    int<lower=1> K1;
    // number of beta parameters for dprime
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
generated quantities {
    /* 
    PARAMETERS
    */
    // hyper prior on the mean of beta parameters for dprime /criterion
    vector[K1] mu_beta_dprime;
    vector[K2] mu_beta_criterion; 
    // variation among individuals in beta parameters (with grand mean)
    vector<lower=0>[K1] tau_u_beta_dprime;
    vector<lower=0>[K2] tau_u_beta_criterion;
    // Cholesky factors for the correlation of beta parameters (dependency within an individual)
    cholesky_factor_corr[K1] Lcorr_beta_dprime; 
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
    /* 
    GENERATED PARAMETERS / MODEL
    */
    // intercept (grand mean)
    mu_beta_dprime[1] = normal_rng(1, 0.5);
    mu_beta_criterion[1] = normal_rng(0.5, 0.5);
    // remaining beta parameters
    for (i in 2:K1){
        mu_beta_dprime[i] = normal_rng(0, 0.5);
    }
    for (i in 2:K2){
        mu_beta_criterion[i] = normal_rng(0, 0.5);
    }
    // random effects (participants)
    for (i in 1:K1){
        tau_u_beta_dprime[i] = gamma_rng(5, 10);
    }
    for (i in 1:K2){
        tau_u_beta_criterion[i] = gamma_rng(5, 10);
    }
    Lcorr_beta_dprime = lkj_corr_cholesky_rng(K1, 2);
    Lcorr_beta_criterion = lkj_corr_cholesky_rng(K2, 2);
    for (i in 1:K1) {
        for (j in 1:S_olditems){
            z_u_beta_dprime[i,j] = std_normal_rng();
        }
    }
    for (i in 1:K2) {
        for (j in 1:S_newitems) {
            z_u_beta_criterion[i,j] = std_normal_rng();
        }
    }
    // random effects (studies)
    for (i in 1:K1){
        tau_w_beta_dprime[i] = uniform_rng(0.01, 0.3);
    }
    for (i in 1:K2){
        tau_w_beta_criterion[i] = uniform_rng(0.01, 0.3);
    }
    for (i in 1:K1) {
        for (j in 1:St_olditems){
            z_w_beta_dprime[i,j] = std_normal_rng();
        }
    }
    for (i in 1:K2) {
        for (j in 1:St_newitems){
            z_w_beta_criterion[i,j] = std_normal_rng();
        }
    }
    // fixed effects (semantic category)
    gm_c_beta_dprime = normal_rng(0, 0.5);
    gm_c_beta_criterion = normal_rng(0, 0.5);
    /* 
    TRANSFORMED PARAMETERS
    */    
    // Correlation matrices for beta parameters (within individuals)
    corr_matrix[K1] R_beta_dprime; 
    corr_matrix[K2] R_beta_criterion;
    // Calculating correlation matrices from Cholesky factors
    R_beta_dprime = multiply_lower_tri_self_transpose(Lcorr_beta_dprime);
    R_beta_criterion = multiply_lower_tri_self_transpose(Lcorr_beta_criterion);
    // Adjustments of beta parameters for individuals
    matrix[K1, S_olditems] u_beta_dprime;
    matrix[K2, S_newitems] u_beta_criterion;
    u_beta_dprime = diag_pre_multiply(tau_u_beta_dprime, Lcorr_beta_dprime) * z_u_beta_dprime;
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
            mu_beta_dprime 
            + u_beta_dprime[:, sub_id_olditems[i]]
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
    /* 
    PREDICTED DATA
    */
    int y_count_olditems_pred [N_olditems];
    int y_count_newitems_pred [N_newitems];
    y_count_olditems_pred = binomial_rng(n_count_olditems, theta_olditems);
    y_count_newitems_pred = binomial_rng(n_count_newitems, theta_newitems);
}

