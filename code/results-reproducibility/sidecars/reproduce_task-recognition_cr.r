require(jsonlite)

sidecar_list <- list(
  condition = list(
    Description = unbox("Indicates experimental condition."),
    Levels = list(
        CSp = unbox("CS+ condition"),
        CSm = unbox("CS- condition")
    )
  ),
  phase = list(
    Description = unbox("Indicates the study phase from day 1 to which the recognition performance corresponds."),
    Levels = list(
        pre_conditioning = unbox("Phase before the conditioning task."),
        conditioning = unbox("Phase of the conditioning task."),
        post_conditioning = unbox("Phase after the conditioning task.")
    )
  ),
  hit = list(
    Description = unbox("Indicates the hit rate."),
    Value = unbox("Real")
  ),
  fa = list(
    Description = unbox("Indicates the false alarm rate."),
    Value = unbox("Real")
  ),
  CR = list(
    Description = unbox("Indicates corrected recognition (i.e, hit - fa)."),
    Value = unbox("Real")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


