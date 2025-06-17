args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 3) {
  stop("Usage: 
  Rscript script.R  <stanfit>
                    <covariates>
                    <output_file>")
}

require(rstan)
require(tidyverse)

#-------------------------
# Read the args
#-------------------------

stanfit_file <- args[1]
covariates_file <- args[2]
output_file <- args[3]

#-------------------------
# Load 
#-------------------------

stanfit <- readRDS(stanfit_file)
df_covs <- readRDS(covariates_file)

#-------------------------
# Extract
#-------------------------

samples <- as.matrix(stanfit)
p_z_samples <- samples[, 2:286]


corr_alpha <- vapply(
  1:nrow(p_z_samples),
  function(i) {
    cor(p_z_samples[i, ], 
    df_covs[["alpha_scaled"]], 
    method = "spearman", use = "complete.obs")},
  numeric(1)
)

corr_delta_scr <- vapply(
  1:nrow(p_z_samples),
  function(i) {
    cor(p_z_samples[i, ], 
    df_covs[["delta_scr_ttp_scaled"]], 
    method = "spearman", use = "complete.obs")
  },
  numeric(1)
)

corr_avg_scr <- vapply(
  1:nrow(p_z_samples),
  function(i) {
    cor(p_z_samples[i, ], 
    df_covs[["avg_scr_ttp_scaled"]], 
    method = "spearman", use = "complete.obs")
  },
  numeric(1)
)

study1_indx <- df_covs[["study_id"]] == unique(df_covs[["study_id"]])[1]
study2_indx <- df_covs[["study_id"]] == unique(df_covs[["study_id"]])[2]
study3_indx <- df_covs[["study_id"]] == unique(df_covs[["study_id"]])[3]
study4_indx <- df_covs[["study_id"]] == unique(df_covs[["study_id"]])[4]

# hard assignment
p_z_class <- ifelse(colMeans(p_z_samples) > 0.5, 1, 0)

prop1 <- sum(p_z_class[study1_indx]) / sum(study1_indx)
prop2 <- sum(p_z_class[study2_indx]) / sum(study2_indx)
prop3 <- sum(p_z_class[study3_indx]) / sum(study3_indx)
prop4 <- sum(p_z_class[study4_indx]) / sum(study4_indx)

# soft assignment

# Helper function to subsample two vectors to the same (smallest) size
subsample_pair <- function(x, y) {
  min_len <- min(length(x), length(y))
  x_sub <- sample(x, min_len, replace = FALSE)
  y_sub <- sample(y, min_len, replace = FALSE)
  return(list(x = x_sub, y = y_sub))
}

set.seed(1234)

ks_study <- vapply(
  1:nrow(p_z_samples),
  function(i) {

    s1 <- p_z_samples[i, study1_indx]
    s2 <- p_z_samples[i, study2_indx]
    s3 <- p_z_samples[i, study3_indx]
    s4 <- p_z_samples[i, study4_indx]

    # Subsample and compute KS statistics
    s1_s2 <- subsample_pair(s1, s2)
    ks_s1_vs_s2 <- ks.test(s1_s2$x, s1_s2$y)$statistic

    s1_s3 <- subsample_pair(s1, s3)
    ks_s1_vs_s3 <- ks.test(s1_s3$x, s1_s3$y)$statistic

    s1_s4 <- subsample_pair(s1, s4)
    ks_s1_vs_s4 <- ks.test(s1_s4$x, s1_s4$y)$statistic

    s2_s3 <- subsample_pair(s2, s3)
    ks_s2_vs_s3 <- ks.test(s2_s3$x, s2_s3$y)$statistic

    s2_s4 <- subsample_pair(s2, s4)
    ks_s2_vs_s4 <- ks.test(s2_s4$x, s2_s4$y)$statistic

    s3_s4 <- subsample_pair(s3, s4)
    ks_s3_vs_s4 <- ks.test(s3_s4$x, s3_s4$y)$statistic

    vec <- c(ks_s1_vs_s2, ks_s1_vs_s3, ks_s1_vs_s4, ks_s2_vs_s3, ks_s2_vs_s4, ks_s3_vs_s4)
    return(vec)
  },
  numeric(6)
)


data <- list(
  p_z_samples = p_z_samples,
  corr_alpha = corr_alpha, 
  corr_avg_scr = corr_avg_scr, 
  corr_delta_scr = corr_delta_scr,
  prop_study = c(prop1, prop2, prop3, prop4),
  ks_study = ks_study,
  study1_indx = study1_indx,
  study2_indx = study2_indx,
  study3_indx = study3_indx,
  study4_indx = study4_indx,
  df_covs = df_covs
)

#-------------------------
# Save
#-------------------------

saveRDS(data, file = output_file)
