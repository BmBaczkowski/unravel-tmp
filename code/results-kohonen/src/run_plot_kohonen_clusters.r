#!/usr/local/bin/R

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop("Usage: 
  Rscript script.R  <file> <file_list>")
}

#-------------------------
# Read the args
#-------------------------
require(kohonen)
require(factoextra)
require(RColorBrewer)
require(ggplot2)


som_file <- args[1]
target_list <- args[2]
target_dir <- dirname(target_list)
mdl_type <- strsplit(target_list, "_")[[1]][2]

#-------------------------
# Load 
#-------------------------
som_objs <- readRDS(som_file)
som_model <- som_objs$som_model
W_t <- som_objs$W_t
U_t <- som_objs$U_t

#-------------------------
# PLOT
#-------------------------
set.seed(123)
# Extracting Codebook Vectors:
codes <- getCodes(som_model)

# Save silhouette plot to PDF
target_files <- c()

target_files <- c(
  target_files, 
  file.path(target_dir, sprintf("som_%s_clst_codes.pdf", mdl_type))
  )
pdf(target_files[length(target_files)])


fviz_nbclust(
  codes,  
  FUNcluster = kmeans,  
  method = "silhouette")

dev.off()

target_files <- c(
  target_files, 
  file.path(target_dir, sprintf("som_%s_clst_data.pdf", mdl_type))
  )
pdf(target_files[length(target_files)])

fviz_nbclust(
  scale(W_t),  
  FUNcluster = kmeans,  
  method = "silhouette")

dev.off()

# retrospectively
som_kmeans <- kmeans(codes, centers = 2, nstart = 25)


# SOM nodes are mapped to input data points. 
# After clustering the nodes, each data point can be asigned to 
# the cluster of its Best Matching Unit (BMU):
indx <- som_kmeans$cluster[som_objs$som_model$unit.classif]

print("2 clusters solution:")
print(som_kmeans$size)
for (i in 1:2){
    print(round(colMeans(W_t[indx==i,]), 3))
}

colors <- brewer.pal(n = 6, name = "Set2")
brewer_palette <- colorRampPalette(brewer.pal(6, "Set2"))
labels <- c(
  expression(beta[1]~":="~"grand mean"),
  expression(beta[2]~":="~Delta~"phase2-phase1"),
  expression(beta[3]~":="~Delta~"phase3-phase2"),
  expression(beta[4]~":="~Delta~"pre-conditioning"),
  expression(beta[5]~":="~Delta~"conditioning"),
  expression(beta[6]~":="~Delta~"post-conditioning")
)

target_files <- c(
  target_files, 
  file.path(target_dir, sprintf("som_%s_clst_.pdf", mdl_type))
  )
pdf(target_files[length(target_files)])

# par(mar = c(5,5,5,5)) 
plot(som_model,
     type = 'codes',
     keepMargins = F,
     col = NA,
     main = 'Kohonen self-organising map',
     palette.name = brewer_palette
     )
legend(
    # "bottom", 
    x = 1.2, 
    y = .8,
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

dev.off()

property_palette <- colorRampPalette(rev(brewer.pal(11, "BrBG")))
for (i in 1:6){
  target_files <- c(
    target_files, 
    file.path(target_dir, sprintf("som_%s_feature0%d.pdf", mdl_type, i))
    )
  pdf(target_files[length(target_files)])
  temp_map <- cut(codes[,1], breaks = length(colors), labels = colors)
  plot(som_model, 
    type = "property", 
    property = codes[, i], 
    # main = substitute(beta[i], list(i = i)),
    main = labels[i],
    ncolors = 20,
    zlim = c(-3, 3),
    palette.name = property_palette
    )
  # add.cluster.boundaries(som_model, som_kmeans$cluster, col='black', lwd=4)

  dev.off()
}

writeLines(target_files, target_list)