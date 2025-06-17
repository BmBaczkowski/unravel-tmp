#!/usr/local/bin/R

# Make plot

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop("Usage: Rscript script.R <tsv_file> <target_file>")
}

# Load necessary libraries
require(readr)
require(dplyr)
require(tidyr)
require(ggplot2)

df <- read_tsv(
  args[1], 
  show_col_types = FALSE
  ) %>%
  arrange(study_id) %>%
  mutate(
    study_id = as.numeric(study_id) / 4
  ) %>%
  select(
    -id, -mean_fa
  ) %>%
  select(
    study_id,
    CSm_pre_conditioning, 
    CSm_conditioning, 
    CSm_post_conditioning,
    CSp_pre_conditioning, 
    CSp_conditioning, 
    CSp_post_conditioning,
    CSm_fa,
    CSp_fa
  )

df_long <- df %>%
  mutate(row = row_number()) %>%   # create a row number column
  pivot_longer(cols = -row, names_to = "column", values_to = "value") %>%
  mutate(
    column = factor(column, levels = c(
      "study_id",
      "CSm_pre_conditioning", 
      "CSm_conditioning", 
      "CSm_post_conditioning",
      "CSp_pre_conditioning", 
      "CSp_conditioning", 
      "CSp_post_conditioning",
      "CSm_fa",
      "CSp_fa"
    ))
  )

# Target file
pdf_file <- args[2]

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
  custom_labels <- c(
    "Study",
    "CS- (I)",
    "CS- (II)",
    "CS- (III)",
    "CS+ (I)",
    "CS+ (II)",
    "CS+ (III)",
    "CS- (FA)",
    "CS+ (FA)"
  )

# Modify plotting here to make the matrix horizontal
  p <- ggplot(df_long, aes(x = row, y = column, fill = value)) +  # switch x and y
    geom_tile() +
    theme_minimal() +
    labs(x = "Participants", y = "", fill = "Proportion") +  # Adjust labels
    scale_y_discrete(labels = custom_labels) +  # Apply custom labels to the y-axis
    scale_fill_gradient(low = "#eff3ff", high = "#2171b5") +  # Single color gradient
    theme(
      axis.title.x = element_text(size = 10, face = "plain"),
      axis.title.y = element_text(size = 10, face = "plain"),
      axis.text.x = element_blank(),
      legend.text = element_text(size = 6),
      legend.key.size = unit(.5, "cm"),         # Increase the height of the color gradient
      legend.key.width = unit(.2, "cm"),        # Adjust the width of the color gradient
      legend.position = "right") +
    coord_fixed(ratio = 10) +  # Adjust the ratio to make the plot horizontal
    guides(
      fill = guide_colorbar(title.theme = element_text(size = 6)) 
    ) 

  print(p)
  dev.off()
}