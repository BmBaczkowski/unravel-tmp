require(jsonlite)

sidecar_list <- list(
  id = list(
    Description = unbox("Unique participant id (sub-id_study_id)"),
    Value = unbox("Real")
  ),
  CSm_conditioning = list(
    Description = unbox("Hit rate of CS- condition in the conditioning phase"),
    Value = unbox("Real")
  ),
  CSm_post_conditioning = list(
    Description = unbox("Hit rate of CS- condition in the post-conditioning phase"),
    Value = unbox("Real")
  ),
  CSm_pre_conditioning = list(
    Description = unbox("Hit rate of CS- condition in the pre-conditioning phase"),
    Value = unbox("Real")
  ),
  CSm_fa = list(
    Description = unbox("False alarm rate of CS- condition"),
    Value = unbox("Real")
  ),
  CSp_conditioning = list(
    Description = unbox("Hit rate of CS+ condition in the conditioning phase"),
    Value = unbox("Real")
  ),
  CSp_post_conditioning = list(
    Description = unbox("Hit rate of CS+ condition in the post-conditioning phase"),
    Value = unbox("Real")
  ),
  CSp_pre_conditioning = list(
    Description = unbox("Hit rate of CS+ condition in the pre-conditioning phase"),
    Value = unbox("Real")
  ),
  CSp_fa = list(
    Description = unbox("False alarm rate of CS+ condition"),
    Value = unbox("Real")
  ),
  mean_fa = list(
    Description = unbox("Average false alarm rate across CS- and CS+."),
    Value = unbox("Real")
  )
)

sidecar <- toJSON(sidecar_list, pretty = TRUE)


