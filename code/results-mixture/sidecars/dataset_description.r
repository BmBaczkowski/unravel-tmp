require(jsonlite)

sidecar_list <- list(
  Name = unbox("Extending baseline models with latent mixture"),
  DatasetType = unbox("results"),
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
      URL = unbox("bids::results-mdl"),
      Version = unbox("This dataset")
    )
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


