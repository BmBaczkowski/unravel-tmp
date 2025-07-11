#!/usr/local/bin/R

# Make plot

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 7) {
  stop("Usage: Rscript script.R 
      <data.rds> 
      <stanfit_file> 
      <plot_main_func_file> 
      <plot_corr_func_file> 
      <hpdi_func> 
      <rope_func> 
      <target_file>"
      )
}

# load data
data_file <- args[1]
data <- readRDS(data_file)
Xc <- data[['data_list']][['X_design_olditems']][1:6, 1:6]
rm(data)

# load stanfit
stanfit_file <- args[2]
stanfit <- readRDS(stanfit_file)
samples <- as.matrix(stanfit)
parnames <- colnames(samples)
rm(stanfit)

# load HPDI func
HPDI_func <- local({
  source(args[5], local = TRUE)
  get("QIofMCMC")
})

get_p_rope <- local({
  source(args[6], local = TRUE)
  get("get_p_rope")
})

# get posterior predictions
vec <- c(1,4,2,5,3,6)
prob = .89
dprime_betas <- samples[, 1:6]
dprime_betas_means <- colMeans(dprime_betas)
dprime_betas_hpdi <- apply(dprime_betas, 2, function(col) {
  HPDI_func(col, prob)
}) # 2 by 6
dprime_betas_rope <- apply(dprime_betas, 2, function(col) {
  p <- round(get_p_rope(col, lb = -.1, ub = .1), 2)
  p_ <- sub("^0", "", as.character(p))
  if (p_ == "") {
    p_ <- ".00"
  }
  return(p_)
})

dprime_samples <- Xc %*% t(dprime_betas) # 6 by S
dprime_means <- rowMeans(dprime_samples)
dprime_means <- dprime_means[vec]
dprime_hpdi <- apply(dprime_samples, 1, function(row) {
  HPDI_func(row, prob)
}) # 2 by 6
dprime_hpdi <- dprime_hpdi[, vec]

# get corr mat
R_mat <- matrix(ncol=6, nrow=6)
R_mat_ub <- matrix(ncol=6, nrow=6)
R_mat_lb <- matrix(ncol=6, nrow=6)
for (i in 1:6){
  for (j in 1:6){
    pattern <- paste0("R_beta_dprime\\[", i, ",", j, "\\]")
    indx <- grep(pattern, parnames)
    corr <- samples[, indx]
    R_mat[i, j] <- round(mean(corr), 2)
    hpdi <- HPDI_func(corr, prob)
    R_mat_lb[i, j] <- round(hpdi[1], 2)
    R_mat_ub[i, j] <- round(hpdi[2], 2)
    R_mat[i, i] <- NA
  }
}

# Load plot function from the specified file 
plot_func <- local({
  source(args[3], local = TRUE)
  get("plot_func")
})
plot_corr_func <- local({
  source(args[4], local = TRUE)
  get("plot_func")
})

# Target file
pdf_file <- args[7]

# Plotting
plotwidth = 12
plotheight = 5

file_extensions <- c('.pdf', '.png')

for (ext in file_extensions) {
  file_name <- sub('.pdf', ext, pdf_file)
  if (ext == '.pdf'){
    pdf(file_name, width = plotwidth, height = plotheight)
  } else if (ext == '.png'){
    png(file_name, width = plotwidth, height = plotheight, units = 'in', res = 300)
  }
  layout(matrix(1:2, 1, 2), widths = c(2, 1))
  plot_func(dprime_means, dprime_hpdi, dprime_betas_means, dprime_betas_hpdi, dprime_betas_rope)
  # size <- .4
  # x1 <- 0.05
  # y1 <- 0.18
  # par(fig=c(x1, x1 + size, y1, y1 + size), new=TRUE, cex=.4, cex.lab=.2)
  plot_corr_func(R_mat, R_mat_lb, R_mat_ub)

  # add panel label
  text(x = grconvertX(0.02, from = "ndc", to = "user"),
      y = grconvertY(0.97, from = "ndc", to = "user"),
      labels = "a)", font = 2, xpd = NA, adj = c(0, 1), cex = 1.2)
  text(x = grconvertX(0.68, from = "ndc", to = "user"),
      y = grconvertY(0.97, from = "ndc", to = "user"),
      labels = "b)", font = 2, xpd = NA, adj = c(0, 1), cex = 1.2)

  dev.off()
}