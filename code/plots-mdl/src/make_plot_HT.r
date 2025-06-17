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

# get rho posterior predictions
vec <- c(1,4,2,5,3,6)
prob = .89
rho_betas <- samples[, 1:6]
rho_betas_rope <- apply(rho_betas, 2, function(col) {
  p <- get_p_rope(col, lb = -.18, ub = .18)
  p_ <- sub("^0", "", as.character(p))
  if (p_ == "") {
    p_ <- ".00"
  }
  return(p_)
})

rho_samples <- Xc %*% t(rho_betas) # 6 by S
rho_means <- plogis(rowMeans(rho_samples))
rho_means <- rho_means[vec]

rho_hpdi <- apply(rho_samples, 1, function(row) {
  plogis(HPDI_func(row, prob))
}) # 2 by 6
rho_hpdi <- rho_hpdi[, vec]

# get posterior odds ratio
OR_means <- exp(colMeans(rho_betas))
OR_hpdi <- apply(rho_betas, 2, function(col) {
  exp(HPDI_func(col, prob))
}) # 2 by 6

# get corr mat
R_mat <- matrix(ncol=6, nrow=6)
R_mat_ub <- matrix(ncol=6, nrow=6)
R_mat_lb <- matrix(ncol=6, nrow=6)
for (i in 1:6){
  for (j in 1:6){
    pattern <- paste0("R_beta_rho\\[", i, ",", j, "\\]")
    indx <- grep(pattern, parnames)
    rho_corr <- samples[, indx]
    R_mat[i, j] <- round(mean(rho_corr), 2)
    hpdi <- HPDI_func(rho_corr, prob)
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
  plot_func(rho_means, rho_hpdi, OR_means, OR_hpdi, rho_betas_rope)
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