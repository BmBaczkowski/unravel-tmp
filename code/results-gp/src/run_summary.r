args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 3) {
  stop("Usage: 
  Rscript script.R  <stanfit_file>
                    <summary_func_file>
                    <output_file>")
}


#-------------------------
# Read the args
#-------------------------

stanfit_file <- args[1]
func_file <- args[2]
target_file <- args[3]

#-------------------------
# Load 
#-------------------------

stanfit <- readRDS(stanfit_file)
get_summary_func <- local({
  source(func_file, local = TRUE)
  get("get_summary")
})

#-------------------------
# Get the model summary
#-------------------------

output <- get_summary_func(stanfit)

#-------------------------
# Save
#-------------------------

writeLines(output, con=target_file)
