require(jsonlite)

sidecar_list <- list(
  TaskName = unbox("Pavlovian threat conditioning"),
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
  condition = list(
    Description = unbox("Indicates whether the semantic category was conditioned or not."),
    Levels = list(
        CSp = unbox("Conditioned category (CS+)"),
        CSm = unbox("Not conditioned category (CS-)")
    )
  ),
  shock = list(
    Description = unbox("Indicates whether the shock was administered."),
    Levels = list(
        present = unbox("Shock was administered."),
        absent = unbox("Shock was not administered")
    )
  ),
  response = list(
    Description = unbox("Indicates shock expectancy."),
    Levels = list(
        correct = unbox("Occurance (or the lack thereof) was correctly predicted."),
        incorrect = unbox("Occurance (or the lack thereof) was incorrectly predicted.")
    )
  ),
  RT = list(
    Description = unbox("Indicates the reaction time of the response."),
    Value = unbox("Seconds.")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


