#!/usr/local/bin/R

# Make plot

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 5) {
  stop("Usage: Rscript script.R <performance_file> <ttest_file> <anova_file> <utility_script> <target_file>")
}

# Load necessary libraries
require(readr)
require(dplyr)

overallperformance_df <- read_tsv(
  args[1], 
  show_col_types = FALSE
  )

ttest_df <- read_tsv(
  args[2], 
  show_col_types = FALSE
  )

anova_df <- read_tsv(
  args[3], 
  show_col_types = FALSE
  )

# Load utility functions from the specified file 
subplot1_func <- local({
  source(args[4], local = TRUE)
  get("subplot1")
})
subplot2_func <- local({
  source(args[4], local = TRUE)
  get("subplot2")
})
subplot3_func <- local({
  source(args[4], local = TRUE)
  get("subplot3")
})

# Target file
pdf_file <- args[5]

# Plotting
plotwidth = 8
plotheight = 4

file_extensions <- c('.pdf', '.png')

for (ext in file_extensions) {
  file_name <- sub('.pdf', ext, pdf_file)
  if (ext == '.pdf'){
    pdf(file_name, width = plotwidth, height = plotheight)
  } else if (ext == '.png'){
    png(file_name, width = plotwidth, height = plotheight, units = 'in', res = 300)
  }
  # 1 row, 3 columns
  # par(family = "sans")
  par(mfrow = c(1, 3))  
  par(oma=c(0,1,1,0))
  par(mar=c(5, 4, 4, 2))

  # plot 1
  subplot1_func(overallperformance_df)

  # plot 2
  subplot2_func(ttest_df)

  # plot 3
  subplot3_func(anova_df)

  dev.off()
}