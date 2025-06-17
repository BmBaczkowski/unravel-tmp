#!/usr/local/bin/R

# Make plot

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 3) {
  stop("Usage: Rscript script.R <lf> <plot_func_file> <target_file>")
}

require(colorspace)

lf_obj_file <- args[1]
lf_obj <- readRDS(lf_obj_file)
f <- lf_obj[['f']]
f_ub <- lf_obj[['f_ub']]
f_lb <- lf_obj[['f_lb']]
p_rope <- lf_obj[['p_rope']]
x_scaled <- lf_obj[['x_scaled']]
x <- lf_obj[['x']]


# Load plot function from the specified file 
plot_func_f <- local({
  source(args[2], local = TRUE)
  get("plot_func")
})


# Target file
pdf_file <- args[3]

is_HT <- grepl("HT", pdf_file)
if (is_HT) {
  rope_bound <- 0.18
} else {
  rope_bound <- 0.1
}

# Plotting
plotwidth = 7
plotheight = 3

file_extensions <- c('.pdf', '.png')

for (ext in file_extensions) {
  file_name <- sub('.pdf', ext, pdf_file)
  if (ext == '.pdf'){
    pdf(file_name, width = plotwidth, height = plotheight)
  } else if (ext == '.png'){
    png(file_name, width = plotwidth, height = plotheight, units = 'in', res = 300)
  }
  
  layout_matrix <- rbind(
    c(1, 2, 6),
    c(3, 4, 5)
  )
  # layout(layout_matrix, widths = c(1, 1, 1.3, 1.3), heights = c(.1, .3, .3, .3))
  layout(layout_matrix)
  # layout.show(n = max(layout_matrix))

  # par(mar = c(0, 0, 0, 0))

  n_colors <- 100
  gradient_colors <- rev(hcl.colors(n_colors, 'Blues 2'))
  ylabs <- c(
    expression(beta[1]),
    expression(beta[2]),
    expression(beta[3]),
    expression(beta[4]),
    expression(beta[5]),
    expression(beta[6])
  )
  titles <- c(
    expression("grand mean"),
    expression(Delta~"phase2-phase1"),
    expression(Delta~"phase3-phase2"),
    expression(Delta~"pre-conditioning"),
    expression(Delta~"conditioning"),
    expression(Delta~"post-conditioning")
  )

  for (i in 2:6){
    par(mar = c(2, 2, 1, 0)) 
    par(mgp=c(2.5, 0.5, 0))
    par(cex.lab = 1)
    plot_func_f(
      f[,i], 
      f_ub[,i], 
      f_lb[,i], 
      x_scaled, 
      x, 
      p_rope[,i], 
      ylabs[i], 
      titles[i], 
      gradient_colors,
      rope_bound
    )
  }

  par(mar = c(1, 1, 1, 1))
  plot(0, type = "n", axes = FALSE, xlab = "", ylab = "")
  legend("center", 
    legend = c("mean", "89% HPD", "ROPE", expression(Pr(ROPE) == 0), expression(Pr(ROPE) == 1)),
    col = 'black', 
    pt.bg = c('black', 'black', 'black', gradient_colors[1], gradient_colors[100]), 
    pch = c(NA, NA, NA, 22, 22),
    lty = c(1, 2, 3, NA, NA),
    cex = 1.1,
    pt.cex = 1.5,
    # bty = "n",  # No box around the legend
    xpd = TRUE
  ) 

  dev.off()
}