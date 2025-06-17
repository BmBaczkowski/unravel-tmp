require(jsonlite)

sidecar_list <- list(
  Name = unbox("Bayesian model of recognition memory"),
  Type = unbox("plot"),
  License = unbox("CC-BY-4.0"),
  Authors = c("Blazej M. Baczkowski"),
  Acknowledgements = unbox("Special thanks to Dr. Felix Kalbe for sharing the original dataset."),
  GeneratedBy = list(
    Name = unbox("Custom code"),
    CodeURL = unbox("bids::code/plots-mdl/Makefile"),
    Container = unbox("bids::dockerfiles/r-stan")
  ),
  SourceDatasets = list(
    list(
      URL = unbox("bids::results-mdl"),
      Version = unbox("This dataset.")
    )
  ),
  Description = list(
    panel_a = unbox("Depicts posterior estimates of memory recognition (d' parameter) derived from beta weights; square brackets indicate 89% HPD interval; Pr(ROPE) indicates the proportion of the posterior falling inside the region of practical equivalence, which is +/-0.1"),
    panel_b = unbox("Depicts within-subject correlation matrix (mean [89% HPD: LB, UB])")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


