require(jsonlite)

sidecar_list <- list(
  TaskName = unbox("Object classification"),
  category = list(
    Description = unbox("Indicates the semantic category."),
    Levels = list(
        tool = unbox(""),
        animal = unbox("")
    )
  ),
  item_id = list(
    Description = unbox("Indicates which picture was presented."),
    Value = unbox("Integer")
  ),
  response = list(
    Description = unbox("Indicates the decision of the participant whether the picture presents an animal or a tool."),
    Levels = list(
        correct = unbox(""),
        incorrect = unbox("")
    )
  ),
  RT = list(
    Description = unbox("Indicates the reaction time of the response."),
    Value = unbox("Seconds.")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


