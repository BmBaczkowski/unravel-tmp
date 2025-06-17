require(jsonlite)

sidecar_list <- list(
  Name = unbox("Bayesian model of recognition memory with latent mixture of two sub-groups of participants"),
  Type = unbox("plot"),
  License = unbox("CC-BY-4.0"),
  Authors = c("Blazej M. Baczkowski"),
  Acknowledgements = unbox("Special thanks to Dr. Felix Kalbe for sharing the original dataset."),
  GeneratedBy = list(
    Name = unbox("Custom code"),
    CodeURL = unbox("bids::code/results-mixture/Makefile"),
    Container = unbox("bids::dockerfiles/r-stan")
  ),
  SourceDatasets = list(
    list(
      URL = unbox("bids::results-mixture"),
      Version = unbox("This dataset.")
    )
  ),
  Description = list(
      top = unbox("Depicts posterior estimates of memory recognition (rho parameter) derived from beta weights in group 1; square brackets indicate 89% HPD interval; Pr(ROPE) indicates the proportion of the posterior falling inside the region of practical equivalence, which is +/-0.1. inset plot in the top right corner depicts the distribution of the base rate of the group 1"),
      bottom = unbox("Depicts posterior estimates of memory recognition (rho parameter) derived from beta weights in group 2; square brackets indicate 89% HPD interval; Pr(ROPE) indicates the proportion of the posterior falling inside the region of practical equivalence, which is +/-0.1")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


