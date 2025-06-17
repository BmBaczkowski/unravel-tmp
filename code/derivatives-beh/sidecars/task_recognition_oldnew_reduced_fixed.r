require(jsonlite)

sidecar_list <- list(
  condition = list(
    Description = unbox("Indicates experimental condition."),
    Levels = list(
        CSp = unbox("CS+ condition"),
        CSm = unbox("CS- condition")
    )
  ),
  first_presentation = list(
    Description = unbox("Indicates the task in which items were presented for the first time."),
    Levels = list(
        pre_conditioning = unbox("Items presented first time in the pre-conditioning task on day 1."),
        conditioning = unbox("Items presented first time in the conditioning task on day 1."),
        post_conditioning = unbox("Items presented first time in the post-conditioning task on day 1."),
        recognition = unbox("Items presented first time in the recognition task on day 2.")
    )
  ),
  status = list(
    Description = unbox("Indicates whether the items were presented before the recognition task."),
    Levels = list(
        old = unbox("Items were presented on day 1."),
        new = unbox("Items were not presented on day 1.")
    )
  ),
  category = list(
    Description = unbox("Indicates the semantic category."),
    Levels = list(
        tool = unbox(""),
        animal = unbox("")
    )
  ),
  n_old = list(
    Description = unbox("Indicates the number of responses indicating 'old' in a respective condition."),
    Value = unbox("Integer.")
  ),
  n_total = list(
    Description = unbox("Indicates the total number of trials per condition regardless whether a response was provided (i.e., 30, 30, 30, 90)"),
    Value = unbox("Integer.")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


