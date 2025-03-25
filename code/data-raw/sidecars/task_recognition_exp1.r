require(jsonlite)

sidecar_list <- list(
  TaskName = unbox("Memory recognition"),
  condition = list(
    Description = unbox("Indicates whether the semantic category was conditioned or not."),
    Levels = list(
        CSp = unbox("Conditioned category (CS+)"),
        CSm = unbox("Not conditioned category (CS-)")
    )
  ),
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
  item_first_presentation = list(
    Description = unbox("Indicates the task in which the picture / item was presented for the first time."),
    Levels = list(
        pre_conditioning = unbox("Item presented first time in the pre-conditioning task on day 1."),
        conditioning = unbox("Item presented first time in the conditioning task on day 1."),
        post_conditioning = unbox("Item presented first time in the post-conditioning task on day 1."),
        recognition = unbox("Item presented first time in the recognition task on day 2.")
    )
  ),
  item_status = list(
    Description = unbox("Indicates whether the picture was presented before the recognition task."),
    Levels = list(
        old = unbox("Picture was presented on day 1."),
        new = unbox("Picture was not presented on day 1.")
    )
  ),
  response = list(
    Description = unbox("Indicates the decision of the participant whether the picture is old or new."),
    Levels = list(
        old = unbox("Response that the picture is recognised as old."),
        new = unbox("Response that the picture is recognised as new.")
    )
  ),
  RT_response = list(
    Description = unbox("Indicates the reaction time of the old / new response."),
    Value = unbox("Seconds.")
  ),
  confidence = list(
    Description = unbox("Indicates the confidence of the old / new decision of the participant if the old / new response is provided."),
    Levels = list(
        very_unsure = unbox(""),
        rather_unsure = unbox(""),
        rather_sure = unbox(""),
        very_sure = unbox("")
    )
  ),
  RT_confidence = list(
    Description = unbox("Indicates the reaction time of the confidence response."),
    Value = unbox("Seconds.")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


