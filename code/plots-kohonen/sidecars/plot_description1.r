require(jsonlite)

sidecar_list <- list(
  Name = unbox("Kohonen self-organising maps and clustering"),
  Type = unbox("plot"),
  License = unbox("CC-BY-4.0"),
  Authors = c("Blazej M. Baczkowski"),
  Acknowledgements = unbox("Special thanks to Dr. Felix Kalbe for sharing the original dataset."),
  GeneratedBy = list(
    Name = unbox("Custom code"),
    CodeURL = unbox("bids::code/results-kohonen/Makefile"),
    Container = unbox("bids::dockerfiles/r-stan")
  ),
  SourceDatasets = list(
    list(
      URL = unbox("bids::results-kohonen"),
      Version = unbox("This dataset.")
    )
  ),
  Description = unbox("The SOM grid consists of a hexagonal layout with 8 x 7 nodes, providing a 2D representation of the high-dimensional data while preserving its topological structure. The network was trained on the scaled features of individual beta weights extracted from Bayesian models. Data points mapped to neighboring nodes share similar feature profiles. The standard Kohonen SOM plot on the left depicts pie representatons of the representative vectors for the grid cells, where the radius of a wedge corresponds to the magnitude in a particular dimension. Maps on the right depict how individual features vary across the SOM (values were normalised and range from -3.2 to 3.2).")
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


