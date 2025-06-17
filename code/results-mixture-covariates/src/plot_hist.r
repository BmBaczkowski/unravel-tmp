args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop("Usage: 
  Rscript script.R  <covariates>
                    <output_file>")
}

#-------------------------
# Read the args
#-------------------------

covariates_file <- args[1]
output_file <- args[2]

#-------------------------
# Load 
#-------------------------

data <- readRDS(covariates_file)

#-------------------------
# Plot
#-------------------------

p_z_samples <- data[['p_z_samples']]

ecdf1 <- ecdf(colMeans(p_z_samples[, data$study1_indx]))
ecdf2 <- ecdf(colMeans(p_z_samples[, data$study2_indx]))
ecdf3 <- ecdf(colMeans(p_z_samples[, data$study3_indx]))
ecdf4 <- ecdf(colMeans(p_z_samples[, data$study4_indx]))


pdf(output_file)

plot(ecdf1, verticals=TRUE, do.points=FALSE, col='black',
  main="ECDF", 
  ylab="ECDF", 
  xlab="Mean posterior probabilities")
plot(ecdf2, verticals=TRUE, do.points=FALSE, add=TRUE, col='brown')
plot(ecdf3, verticals=TRUE, do.points=FALSE, add=TRUE, col='orange')
plot(ecdf4, verticals=TRUE, do.points=FALSE, add=TRUE, col='red')
x <- seq(0.01, .99, by=.01)
y <- pbeta(x, 1,1)
lines(x, y, col='blue')

legend("topleft", legend=c("study 1", "study 2", "study 3", "study 4", "CDF uniform"),
       col=c("black", "brown", "orange", "red", "blue"), lty=c(1, 1, 1, 1, 1))


dev.off()
