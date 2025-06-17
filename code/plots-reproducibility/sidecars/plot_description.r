require(jsonlite)

sidecar_list <- list(
  Name = unbox("Outcome of the reproducibility process regarding memory recognition test"),
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
  Description = list(
    panel_a = unbox("Overall performance (hit rate and false alarm rate)"),
    panel_b = unbox("Paired t-test (corrected recognition)"),
    panel_c = unbox("Repeated measures ANOVA (corrected recognition)")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


