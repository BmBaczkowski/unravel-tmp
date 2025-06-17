args <- commandArgs(trailingOnly = TRUE)


get_args <- function(...) {
  # Capture the arguments as a list
  args <- list(...)
  
  # Convert the list to numeric and calculate the sum
  file_list <- unlist(args)
  names(file_list) <- NULL

  return(file_list)
}

file_list <- get_args(... = args)

if (length(file_list) < 3) {
  stop("Usage: 
  Rscript script.R  <gqs_mdl_a>
                    <...>
                    <gqs_mdl_b>
                    <...>
                    <output_file>")
}


#-------------------------
# Read the args
#-------------------------

gqs_files <- file_list[1:(length(file_list) - 1)]
output_file <- file_list[[length(file_list)]]
n <- length(gqs_files)
gqs1_files <- gqs_files[1:(n/2)]
gqs2_files <- gqs_files[((n/2)+1):n]


#-------------------------
# Load 
#-------------------------

require(loo)

mdl1_log_lik <- list()
for (i in seq_along(gqs1_files)) {
  gqs <- readRDS(gqs1_files[[i]])
  mdl1_log_lik[[i]] <- as.matrix(extract_log_lik(gqs))
}
mdl2_log_lik <- list()
for (i in seq_along(gqs2_files)) {
  gqs <- readRDS(gqs2_files[[i]])
  mdl2_log_lik[[i]] <- as.matrix(extract_log_lik(gqs))
}
mdl1_log_lik <- do.call(cbind, mdl1_log_lik)
mdl2_log_lik <- do.call(cbind, mdl2_log_lik)

elpd1 <- elpd(mdl1_log_lik)
elpd2 <- elpd(mdl2_log_lik)
elpd_comp <- loo_compare(elpd1, elpd2)

output <- list(
  elpd_comp=elpd_comp,
  elpd1=elpd1,
  elpd2=elpd2
  )
#-------------------------
# Save
#-------------------------

saveRDS(output, file = output_file)
