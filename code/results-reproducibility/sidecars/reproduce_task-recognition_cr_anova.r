require(jsonlite)

sidecar_list <- list(
  effect = list(
    Description = unbox("Indicates the effect of two-way repeated measures ANOVA"),
    Levels = list(
        phase = unbox("the main effect of the phase (i.e., 'pre-conditioning', 'conditioning', 'post-conditioning')"),
        condition = unbox("the main effect of condition (i.e., 'CS+', 'CS-')"),
        phase_condition = unbox("the interaction effect of phase:condition")
    )
  ),
  F = list(
    Description = unbox("Indicates the F statistics of the ANOVA."),
    Value = unbox("Real")
  ),
  F_paper = list(
    Description = unbox("Indicates the F statistics of the ANOVA as reported in the original paper."),
    Value = unbox("Real")
  ),
  abs_error = list(
    Description = unbox("Indicates the absolute difference between obtained and reported F statistics."),
    Value = unbox("Real")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


