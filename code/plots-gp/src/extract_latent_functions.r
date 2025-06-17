#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 5) {
  stop("Usage: Rscript script.R <data> <stanfit> <hpd_func> <p_rope_func> <target_file>")
}

data_file <- args[1]
data <- readRDS(data_file)
x_scaled <- data$data_list$x
x <- data$data_list$x_prime
n <- length(x)

stanfit_file <- args[2]
stanfit <- readRDS(stanfit_file)
samples <- as.matrix(stanfit)
parnames <- colnames(samples)
rm(stanfit)

# load HPDI func
HPDI_func <- local({
  source(args[3], local = TRUE)
  get("QIofMCMC")
})

get_p_rope <- local({
  source(args[4], local = TRUE)
  get("get_p_rope")
})

is_HT <- grepl("HT", stanfit_file)
if (is_HT) {
  rope_bound <- 0.18
} else {
  rope_bound <- 0.1
}

# Extract latent functions
p <- 6
f <- matrix(nrow=n, ncol=p)
f_lb <- matrix(nrow=n, ncol=p)
f_ub <- matrix(nrow=n, ncol=p)
p_rope <- matrix(nrow=n, ncol=p)
prob = .89
for (i in 1:p){
    pattern <- paste0("^f\\[\\d+,", i, "\\]")
    indx <- grep(pattern, parnames)
    f[, i] <- round(colMeans(samples[, indx]), 2)
    f_lb[, i] <- apply(samples[, indx], 2, function(col) {
        round(HPDI_func(col, prob)[1], 2)
    }) 
    f_ub[, i] <- apply(samples[, indx], 2, function(col) {
        round(HPDI_func(col, prob)[2], 2)
    }) 
    p_rope[, i] <- apply(samples[, indx], 2, function(col) {
        get_p_rope(col, lb = -rope_bound, ub = rope_bound)
    }) 
}

target_file <- args[5]
obj <- list(
    f = f, 
    f_lb = f_lb,
    f_ub = f_ub,
    p_rope = p_rope,
    x = x, 
    x_scaled = x_scaled
)
saveRDS(obj, target_file)