require(jsonlite)

sidecar_list <- list(
  Name = unbox("Raw data: hit rates and false alarm rates"),
  Type = unbox("plot"),
  License = unbox("CC-BY-4.0"),
  Authors = c("Blazej M. Baczkowski"),
  Acknowledgements = unbox("Special thanks to Dr. Felix Kalbe for sharing the original dataset."),
  GeneratedBy = list(
    Name = unbox("Custom code"),
    CodeURL = unbox("bids::code/results-reproducibility/Makefile"),
    Container = unbox("bids::dockerfiles/r-stan")
  ),
  SourceDatasets = list(
    list(
      URL = unbox("bids::results-reproducibility"),
      Version = unbox("This dataset.")
    )
  ),
  Description = unbox("Raw hit rates and false alarms per participant (roman numbers indicate phase of the encoding). Last row indicates the study id that is color-coded.")
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


