require(jsonlite)

sidecar_list <- list(
  # category = list(
  #   Description = unbox("Indicates the semantic category."),
  #   Levels = list(
  #       tool = unbox(""),
  #       animal = unbox("")
  #   )
  # ),
  # item_id = list(
  #   Description = unbox("Indicates which picture was presented."),
  #   Value = unbox("Integer")
  # ),
  # condition = list(
  #   Description = unbox("Indicates whether the semantic category was conditioned or not."),
  #   Levels = list(
  #       '1' = unbox("Conditioned category (CS+)"),
  #       '2' = unbox("Not conditioned category (CS-)")
  #   )
  # ),
  # shock = list(
  #   Description = unbox("Indicates whether the shock was administered."),
  #   Levels = list(
  #       '1' = unbox("Shock was administered."),
  #       '0' = unbox("Shock was not administered")
  #   )
  # ),
  # response = list(
  #   Description = unbox("Indicates shock expectancy."),
  #   Levels = list(
  #       '1' = unbox("Indicates that shock is expected."),
  #       '0' = unbox("Indicates that shock is not expected.")
  #   )
  # ),
  # RT = list(
  #   Description = unbox("Indicates the reaction time of the response."),
  #   Value = unbox("Seconds.")
  # )
  trial_id = list(
    Description = unbox("Indicates the order of trials in each condition."),
    Value = unbox("Integer")
  ),
  shock = list(
    Description = unbox("Indicates whether a shock was applied in the CS+ condition."),
    Levels = list(
        '1' = unbox("yes"),
        '0' = unbox("no")
    )
  ),
  response_csp = list(
    Description = unbox("Indicates shock expectancy in the CS+ condition."),
    Levels = list(
        '1' = unbox("Indicates that shock is expected."),
        '0' = unbox("Indicates that shock is not expected.")
    )
  ),
  response_csm = list(
    Description = unbox("Indicates shock expectancy in the CS- condition."),
    Levels = list(
        '1' = unbox("Indicates that shock is expected."),
        '0' = unbox("Indicates that shock is not expected.")
    )
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


