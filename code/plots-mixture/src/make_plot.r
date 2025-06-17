#!/usr/local/bin/R

# Make plot

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 7) {
  stop("Usage: Rscript script.R 
  <data.rds> <stanfit_file> <plot_func_file> <plot_func_file <hpdi_func> <rope_func> <target_file>")
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

# Gr1
pattern <- '^mu_beta_rho1\\[\\d+\\]'
indx <- grep(pattern, parnames)
rho_betas1 <- samples[, indx]
rho_betas_rope1 <- apply(rho_betas1, 2, function(col) {
  p <- get_p_rope(col, lb = -.18, ub = .18)
  p_ <- sub("^0", "", as.character(p))
  if (p_ == "") {
    p_ <- ".00"
  }
  return(p_)
})
rho_samples1 <- Xc %*% t(rho_betas1) # 6 by S
rho_means1 <- plogis(rowMeans(rho_samples1))
rho_means1 <- rho_means1[vec]
rho_hpdi1 <- apply(rho_samples1, 1, function(row) {
  plogis(HPDI_func(row, prob))
}) # 2 by 6
rho_hpdi1 <- rho_hpdi1[, vec]

# get posterior odds ratio
OR_means1 <- exp(colMeans(rho_betas1))
OR_hpdi1 <- apply(rho_betas1, 2, function(col) {
  exp(HPDI_func(col, prob))
}) # 2 by 6


# Gr2
pattern <- '^mu_beta_rho2\\[\\d+\\]'
indx <- grep(pattern, parnames)
rho_betas2 <- samples[, indx]
rho_betas_rope2 <- apply(rho_betas2, 2, function(col) {
  p <- get_p_rope(col, lb = -.18, ub = .18)
  p_ <- sub("^0", "", as.character(p))
  if (p_ == "") {
    p_ <- ".00"
  }
  return(p_)
})
rho_samples2 <- Xc %*% t(rho_betas2) # 6 by S
rho_means2 <- plogis(rowMeans(rho_samples2))
rho_means2 <- rho_means2[vec]
rho_hpdi2 <- apply(rho_samples2, 1, function(row) {
  plogis(HPDI_func(row, prob))
}) # 2 by 6
rho_hpdi2 <- rho_hpdi2[, vec]

# get posterior odds ratio
OR_means2 <- exp(colMeans(rho_betas2))
OR_hpdi2 <- apply(rho_betas2, 2, function(col) {
  exp(HPDI_func(col, prob))
}) # 2 by 6

# get proportions
pattern <- '^phi'
indx <- grep(pattern, parnames)
phi <- round(samples[, indx], 2)
phi_mean <- mean(phi)
phi_hpdi <- HPDI_func(phi, prob)


# Load plot function from the specified file 
plot_func <- local({
  source(args[3], local = TRUE)
  get("plot_func")
})
plot_func_hist <- local({
  source(args[4], local = TRUE)
  get("plot_func")
})

# Target file
pdf_file <- args[7]

# Plotting
plotwidth = 7
plotheight = 8

file_extensions <- c('.pdf', '.png')

for (ext in file_extensions) {
  file_name <- sub('.pdf', ext, pdf_file)
  if (ext == '.pdf'){
    pdf(file_name, width = plotwidth, height = plotheight)
  } else if (ext == '.png'){
    png(file_name, width = plotwidth, height = plotheight, units = 'in', res = 300)
  }


  layout(matrix(c(1, 2), nrow = 2, ncol = 1))

  par(mar = c(4, 5, 2.5, 1)) 
  plot_func(
    rho_means1, 
    rho_hpdi1, 
    OR_means1, 
    OR_hpdi1, 
    rho_betas_rope1, 
    title = 'Group 1', 
    gr = '1', 
    ylim=c(.2, 1)
  )
  # par(mar = c(4, 5, 2.5, 1))
  plot_func(
    rho_means2, 
    rho_hpdi2, 
    OR_means2, 
    OR_hpdi2, 
    rho_betas_rope2, 
    title = 'Group 2', 
    gr = '2', 
    ylim=c(.2, 1)
  )
  # INSET PLOT
  width <- .12
  x1 <- 0.85
  x2 <- x1 + width
  y1 <- 0.85
  y2 <- y1 + width - 0.02
  par(fig=c(x1, x2, y1, y2), new=TRUE, cex=.4, cex.lab=.2)
  plot_func_hist(phi, phi_mean, phi_hpdi)
  box('figure', lty = 1, lwd = 1, col = "grey")

  dev.off()
}