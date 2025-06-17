require(dplyr)
require(tidyr)

reproduce_cr <- function(df) {

    df_hit <- df %>%
        select(-n_old, -n_total) %>%
        filter(measure == "hit") %>%
        select(-status)

    df_fa <- df %>%
        select(-n_old, -n_total) %>%
        filter(measure == "fa") %>%
        select(-category)

    level1 <- c("conditioning", "pre_conditioning", "post_conditioning")

    df_fa <- expand_grid(df_fa, new_ = level1)
    df_fa <- df_fa %>%
        select(-status, -first_presentation) %>%
        rename(
            first_presentation = new_
        ) 

    new_df <- left_join(df_hit, df_fa, by = c(
            "study_id",
            "participant_id", 
            "first_presentation", 
            "condition"
        )) %>%
        select(-measure.x, -measure.y, -category) %>%
        rename(
            phase = first_presentation,
            hit = proportion.x, 
            fa = proportion.y
        ) %>%
        mutate(
            CR = round(hit - fa, 2),
            hit = round(hit, 2),
            fa = round(fa, 2)
        ) 
    return(new_df)
}