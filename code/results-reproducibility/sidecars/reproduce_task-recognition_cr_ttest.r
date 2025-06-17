require(jsonlite)

sidecar_list <- list(
  phase = list(
    Description = unbox("Indicates the phase of the experiment that was analyzed using a paired sample t-test to compare the effects of CS+ and CS- conditions."),
    Levels = list(
        pre_conditioning = unbox(""),
        conditioning = unbox(""),
        post_conditioning = unbox("")
    )
  ),
  t = list(
    Description = unbox("Indicates the t statistics of the paired t-test."),
    Value = unbox("Real")
  ),
  t_paper = list(
    Description = unbox("Indicates the t statistics of the paired t-test as reported in the original paper."),
    Value = unbox("Real")
  ),
  abs_error = list(
    Description = unbox("Indicates the absolute difference between obtained and reported t statistics."),
    Value = unbox("Real")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


