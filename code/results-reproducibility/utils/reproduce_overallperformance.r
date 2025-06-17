require(dplyr)

reproduce_overallperformance <- function(df){
    df <- df %>%
        group_by(study_id, status) %>%
        summarize(
            avg = round(mean(proportion, na.rm=TRUE) * 100, 1), 
            std = round(sd(proportion, na.rm=TRUE), 2),
            .groups = 'drop'
        ) %>%
        mutate(
            status = recode(
            status, 
            "new" = "false_alarm_rate", 
            "old" = "hit_rate"
            ),
            avg_paper = c(
            24.4, 69.6, # exp1
            25.2, 60.9, # exp2
            23.1, 62.7, # exp3
            26.2, 62.8 # exp4
            ), 
            std_paper = c(
            0.09, 0.11,
            0.1, 0.14,
            0.1, 0.16,
            0.1, 0.14
            ),
            avg_abs_error = round(abs(avg - avg_paper), 2), 
            std_abs_error = round(abs(std - std_paper), 2)
        ) %>%
        rename(
            performance = status
        )
    return(df)
}

