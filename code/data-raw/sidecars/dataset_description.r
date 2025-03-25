require(jsonlite)

sidecar_list <- list(
  Name = unbox("Minimally Preprocessed Data"),
  BIDSVersion = unbox("1.8.0"),
  DatasetType = unbox("raw"),
  License = unbox("CC-BY-4.0"),
  Authors = c("Blazej M. Baczkowski"),
  Acknowledgements = unbox("Special thanks to Dr. Felix Kalbe for sharing the original dataset."),
  GeneratedBy = list(
    Name = unbox("Custom code"),
    CodeURL = unbox("bids::code/data-raw/Makefile"),
    Container = unbox("bids::dockerfiles/r-stan")
  ),
  SourceDatasets = list(
    list(
      URL = unbox("https://osf.io/qpm3t/files/osfstorage/5e2f0b8e87a1d9023d1cf591"),
      Version = unbox("2021-01-27 11:33 AM")
    ),
    list(
      URL = unbox("https://osf.io/qpm3t/files/osfstorage/5e2f0b8ec19c5d0252ee012d"),
      Version = unbox("2021-01-27 11:34 AM")
    ),
    list(
      URL = unbox("https://osf.io/qpm3t/files/osfstorage/5e2f0b8d87a1d9024c1cebc2"),
      Version = unbox("2021-01-27 11:34 AM")
    ),
    list(
      URL = unbox("https://osf.io/qpm3t/files/osfstorage/5fc50a1cc623190430d8021d"),
      Version = unbox("2021-01-27 11:34 AM")
    )
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)