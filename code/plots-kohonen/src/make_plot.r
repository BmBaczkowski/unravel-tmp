#!/usr/local/bin/R

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop("Usage: 
  Rscript script.R <som_file> <target_file>")
}

#-------------------------
# Read the args
#-------------------------
require(kohonen)
require(RColorBrewer)


# modify the plot function to deal with margins
func_str <- get("plot.kohprop", envir = asNamespace("kohonen"))
func_str <- deparse(func_str)
func_str <- func_str[-18]
plot.kohprop <- local({
   eval(parse(text = paste(func_str, collapse = "\n")), envir <- asNamespace("kohonen"))
})

som_file <- args[1]
target_file <- args[2]

#-------------------------
# Load 
#-------------------------
som_objs <- readRDS(som_file)
som_model <- som_objs$som_model

#-------------------------
# PLOT
#-------------------------

set.seed(123)
codes <- getCodes(som_model)
som_kmeans <- kmeans(codes, centers = 2, nstart = 25)

colors <- brewer.pal(n = 6, name = "Dark2")
brewer_palette <- colorRampPalette(brewer.pal(6, "Dark2"))
property_palette <- colorRampPalette(rev(brewer.pal(11, "BrBG")))
labels <- c(
  expression(beta[1]~":="~"grand mean"),
  expression(beta[2]~":="~Delta~"phase2-phase1"),
  expression(beta[3]~":="~Delta~"phase3-phase2"),
  expression(beta[4]~":="~Delta~"pre-conditioning"),
  expression(beta[5]~":="~Delta~"conditioning"),
  expression(beta[6]~":="~Delta~"post-conditioning")
)
# labels2 <- c(
#   expression(beta[1]),
#   expression(beta[2]),
#   expression(beta[3]),
#   expression(beta[4]),
#   expression(beta[5]),
#   expression(beta[6])
# )

plotwidth = 8
plotheight = 4


file_extensions <- c('.pdf', '.png')

for (ext in file_extensions) {
  file_name <- sub('.pdf', ext, target_file)
  if (ext == '.pdf'){
    pdf(file_name, width = plotwidth, height = plotheight)
  } else if (ext == '.png'){
    png(file_name, width = plotwidth, height = plotheight, units = 'in', res = 300)
  }

  layout_matrix <- rbind(
    c(1, 1, 2, 3),
    c(1, 1, 4, 5),
    c(1, 1, 6, 7)
  )
  layout(layout_matrix, widths = c(1.5, 1.5, 1, 1))
  # layout.show(n = max(layout_matrix))
  par(oma = c(0, 0, 1, 0))   # Outer margin: bottom, left, top, right

  par(font.main = 1)
  plot(som_model,
      type = 'codes',
      keepMargins = FALSE,
      whatmap = 1,
      col = NA,
      main = NA,
      # main = expression(atop('Kohonen self-organising map', '(' * beta * ' weights)')),
      palette.name = brewer_palette
      )
  legend(
      # "top", 
      x = 1.2, 
      y = 8.5,
      # inset=c(0,-.1),
      # legend = paste("Feature", 1:6), 
      legend = labels,
      fill = colors, 
      title = NA, 
      bty = "n",
      # horiz = TRUE, 
      xpd = TRUE,
      ncol = 2
  )
  add.cluster.boundaries(som_model, som_kmeans$cluster, col='black', lwd=4)
  
  for (i in 1:6){
    par(xpd=TRUE, cex.main=.9) 
    par(mar = c(0,0,1,0))
    plot.kohprop(x=som_model,
      # type = "property", 
      keepMargins = TRUE,
      # heatkeywidth = .6,
      property = codes[, i], 
      main = labels[i],
      ncolors = 20,
      zlim = c(-3.2, 3.2),
      palette.name = property_palette,
      border='white', 
      heatkey = FALSE
      )
  }

  # add panel label
  text(x = grconvertX(0.02, from = "ndc", to = "user"),
      y = grconvertY(0.97, from = "ndc", to = "user"),
      labels = "a)", font = 2, xpd = NA, adj = c(0, 1), cex = 1.2)
  text(x = grconvertX(0.58, from = "ndc", to = "user"),
      y = grconvertY(0.97, from = "ndc", to = "user"),
      labels = "b)", font = 2, xpd = NA, adj = c(0, 1), cex = 1.2)


  dev.off()
}