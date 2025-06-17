require(jsonlite)

sidecar_list <- list(
  Name = unbox("Bayesian model of recognition memory with Gaussian Process (GP) extension to include individual differences in skin conductance response (SCR) among participants"),
  Type = unbox("plot"),
  License = unbox("CC-BY-4.0"),
  Authors = c("Blazej M. Baczkowski"),
  Acknowledgements = unbox("Special thanks to Dr. Felix Kalbe for sharing the original dataset."),
  GeneratedBy = list(
    Name = unbox("Custom code"),
    CodeURL = unbox("bids::code/results-gp/Makefile"),
    Container = unbox("bids::dockerfiles/r-stan")
  ),
  SourceDatasets = list(
    list(
      URL = unbox("bids::results-gp"),
      Version = unbox("This dataset.")
    )
  ),
  Description = unbox("Plots depict latent functions that maps input features (difference in SCR between CS+ vs CS-) onto beta weigths (differences in memory recognition). Pr(ROPE) indicates the proportion of the posterior at a particular value of the learning rate that falls within the region of practical equivalence, which is +/-0.18 on the log-odds scale. 
  ")
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


