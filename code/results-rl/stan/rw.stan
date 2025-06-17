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
  // learning rate
  real mu_alpha; // expectation
  real<lower=0> tau_alpha; // variance
  vector [N_subject] alpha; // individual learning rate
}
transformed parameters {
  vector<lower=0, upper=1> [N_subject] alpha_hat;    
  alpha_hat = inv_logit(alpha);

  matrix[N_subject, N_trial] V_CSp = rep_matrix(0.5, N_subject, N_trial);
  matrix[N_subject, N_trial] V_CSm = rep_matrix(0.5, N_subject, N_trial);

  for (t in 1:N){
    // skip first trial
    if (trial_id[t] == 1) {
      continue;
    } 
    V_CSp[subject_id[t], trial_id[t]] = V_CSp[subject_id[t], trial_id[t - 1]] + 
      alpha_hat[subject_id[t]] *
      (shock[t - 1] - V_CSp[subject_id[t], trial_id[t - 1]]);
    
    V_CSm[subject_id[t], trial_id[t]] = V_CSm[subject_id[t], trial_id[t - 1]] + 
      alpha_hat[subject_id[t]] *
      (0 - V_CSm[subject_id[t], trial_id[t - 1]]);
  }
}
model {
  target += normal_lpdf(mu_alpha | 0, 2);
  target += gamma_lpdf(tau_alpha | 5, 10);
  target += normal_lpdf(alpha | mu_alpha, tau_alpha);

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
