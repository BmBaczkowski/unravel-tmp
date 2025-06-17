require(jsonlite)

sidecar_list <- list(
  performance = list(
    Description = unbox("Indicates the metric of performance."),
    Levels = list(
        false_alarm_rate = unbox(""),
        hit_rate = unbox("")
    )
  ),
  avg = list(
    Description = unbox("Indicates the mean of the respective performance metric across individuals."),
    Value = unbox("Real")
  ),
  std = list(
    Description = unbox("Indicates the standard deviation of the respective performance metric across individuals."),
    Value = unbox("Real")
  ),
  avg_paper = list(
    Description = unbox("Indicates the mean of the respective performance metric across individuals as reported in the original paper."),
    Value = unbox("Real")
  ),
  std_paper = list(
    Description = unbox("Indicates the standard deviation of the respective performance metric across individuals as reported in the original paper."),
    Value = unbox("Real")
  ),
  avg_abs_error = list(
    Description = unbox("Indicates the absolute error / difference between the obtained mean and the mean reported in the original paper."),
    Value = unbox("Real")
  ),
  std_abs_error = list(
    Description = unbox("Indicates the absolute error / difference between the obtained standard deviation and the standard deviation reported in the original paper."),
    Value = unbox("Real")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


