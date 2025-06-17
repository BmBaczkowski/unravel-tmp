data {
    // number of data points
    int<lower=1> N;
    // number of subject
    int<lower=1> N_subject;
    // subject id per observation
    int<lower=1,upper=N_subject> subject_id [N];
    // number of trials
    int<lower=1> N_trial;
    // trial id per observation
    int<lower=1,upper=N_trial> trial_id [N];
    // data
    int<lower=0, upper=1> shock [N];
    int<lower=0, upper=1> response_csp [N];
    int<lower=0, upper=1> response_csm [N];

} 
parameters {
  // learning rate parameter
  real mu_alpha;
  real<lower=0> tau_alpha; 
  vector [N_subject] alpha;  
  real mu_eta;
  real<lower=0> tau_eta; 
  vector [N_subject] eta_init;  

}
transformed parameters {
  vector<lower=0, upper=1> [N_subject] alpha_hat;    
  alpha_hat = inv_logit(alpha);
  vector<lower=0, upper=1> [N_subject] eta_init_hat;    
  eta_init_hat = inv_logit(eta_init);

  matrix[N_subject, N_trial] V_CSp = rep_matrix(0.5, N_subject, N_trial);
  matrix[N_subject, N_trial] V_CSm = rep_matrix(0.5, N_subject, N_trial);
  
  matrix[N_subject, N_trial] eta_CSp = rep_matrix(eta_init_hat, N_trial);
  matrix[N_subject, N_trial] eta_CSm = rep_matrix(eta_init_hat, N_trial);

  for (t in 1:N){
    // skip first trial
    if (trial_id[t] == 1) {
      continue;
    } 

    eta_CSp[subject_id[t], trial_id[t]] = alpha_hat[subject_id[t]] * 
        abs(
            V_CSp[subject_id[t], trial_id[t - 1]] - shock[t - 1]
            ) + 
        (1 - alpha_hat[subject_id[t]]) * eta_CSp[subject_id[t], trial_id[t - 1]];

    V_CSp[subject_id[t], trial_id[t]] = V_CSp[subject_id[t], trial_id[t - 1]] + 
      eta_CSp[subject_id[t], trial_id[t - 1]] * 
      (shock[t - 1] - V_CSp[subject_id[t], trial_id[t - 1]]);
      
    eta_CSm[subject_id[t], trial_id[t]] = alpha_hat[subject_id[t]] * 
        abs(
            V_CSm[subject_id[t], trial_id[t - 1]] - 0
            ) + 
        (1 - alpha_hat[subject_id[t]]) * eta_CSm[subject_id[t], trial_id[t - 1]];

    V_CSm[subject_id[t], trial_id[t]] = V_CSm[subject_id[t], trial_id[t - 1]] + 
      eta_CSm[subject_id[t], trial_id[t - 1]] * 
      (0 - V_CSm[subject_id[t], trial_id[t - 1]]);    
      
  }
}
model {
  // learning rate
  target += normal_lpdf(mu_alpha | 0, 2);
  target += gamma_lpdf(tau_alpha | 5, 10);
  target += normal_lpdf(alpha | mu_alpha, tau_alpha);

  // dynamic associability
  target += normal_lpdf(mu_eta | 0, 1.5);
  target += gamma_lpdf(tau_eta | 5, 10);
  target += normal_lpdf(eta_init | mu_eta, tau_eta);

  // likelihood
  for (t in 1:N){
    target += bernoulli_lpmf(response_csp[t] | V_CSp[subject_id[t], trial_id[t]]);
    target += bernoulli_lpmf(response_csm[t] | V_CSm[subject_id[t], trial_id[t]]);
  }
}
generated quantities {
  // Predicted data
  int response_csp_pred [N];
  int response_csm_pred [N];
  // sum of log likelihood
  real log_lik;
  log_lik = 0;
  for (t in 1:N){
    response_csp_pred[t] = bernoulli_rng(V_CSp[subject_id[t], trial_id[t]]);
    response_csm_pred[t] = bernoulli_rng(V_CSm[subject_id[t], trial_id[t]]);

    log_lik += bernoulli_lpmf(response_csp[t] | V_CSp[subject_id[t], trial_id[t]]);
    log_lik += bernoulli_lpmf(response_csm[t] | V_CSm[subject_id[t], trial_id[t]]);
  }
}
