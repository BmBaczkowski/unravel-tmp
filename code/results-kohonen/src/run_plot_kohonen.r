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
require(RColorBrewer)

som_file <- args[1]
target_list <- args[2]
target_dir <- dirname(target_list)
mdl_type <- strsplit(target_list, "_")[[1]][2]
#-------------------------
# Load 
#-------------------------
som_objs <- readRDS(som_file)
som_model <- som_objs$som_model
#-------------------------
# PLOT
#-------------------------


brewer_palette <- colorRampPalette(brewer.pal(9, "Spectral"))

target_files <- c()
target_files <- c(
  target_files, 
  file.path(target_dir, sprintf("som_%s_diag_mapping.pdf", mdl_type))
  )
pdf(target_files[1])
plot(som_model, type = "mapping", pchs = 20, main = "Mapping")
dev.off()

target_files <- c(
  target_files, 
  file.path(target_dir, sprintf("som_%s_diag_neighbours.pdf", mdl_type))
  )
pdf(target_files[2])
plot(som_model, type = "dist.neighbours", pchs = 20, main = "Neighbours", palette.name = brewer_palette)
dev.off()

target_files <- c(
  target_files, 
  file.path(target_dir, sprintf("som_%s_diag_counts.pdf", mdl_type))
  )
pdf(target_files[3])
plot(som_model, type = "counts", main = "Counts", palette.name = brewer_palette, heatkey = TRUE)
dev.off()

target_files <- c(
  target_files, 
  file.path(target_dir, sprintf("som_%s_diag_changes.pdf", mdl_type))
  )
pdf(target_files[4])
plot(som_model, type = "changes", main = "Changes")
dev.off()

target_files <- c(
  target_files, 
  file.path(target_dir, sprintf("som_%s_diag_quality.pdf", mdl_type))
  )
pdf(target_files[5])
plot(som_model, type = "quality", main = "Quality", palette.name = brewer_palette, heatkey = TRUE)
dev.off()

writeLines(target_files, target_list)

