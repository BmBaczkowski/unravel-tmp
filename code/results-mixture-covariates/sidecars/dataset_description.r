require(jsonlite)

sidecar_list <- list(
  Name = unbox("Extracting covariates to check covariate-dependent class membership of the latent mixture"),
  DatasetType = unbox("results"),
  License = unbox("CC-BY-4.0"),
  Authors = c("Blazej M. Baczkowski"),
  Acknowledgements = unbox("Special thanks to Dr. Felix Kalbe for sharing the original dataset."),
  GeneratedBy = list(
    Name = unbox("Custom code"),
    CodeURL = unbox("bids::code/results-mixture-covariates/Makefile"),
    Container = unbox("bids::dockerfiles/r-stan")
  ),
  SourceDatasets = list(
    list(
      URL = unbox("bids::data-raw"),
      Version = unbox("This dataset")
    ),
    list(
      URL = unbox("bids::derivatives-beh"),
      Version = unbox("This dataset")
    ),
    list(
      URL = unbox("bids::derivatives-scr"),
      Version = unbox("This dataset")
    ),
    list(
      URL = unbox("bids::results-rl"),
      Version = unbox("This dataset")
    ),
    list(
      URL = unbox("bids::results-mixture"),
      Version = unbox("This dataset")
    )
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


