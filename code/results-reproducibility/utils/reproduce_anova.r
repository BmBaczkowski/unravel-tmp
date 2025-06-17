require(dplyr)

reproduce_anova <- function(df){
    study_id_list <- levels(df[['study_id']])
    rm_anova_list <- vector("list")
    all_outputs <- c()
    rm_anova_df <- tibble(
        study_id = character(),
        effect = character(),
        F = numeric()
    )

    for (study_id in study_id_list) {
        id <- sprintf("study-%s", study_id)

        rm_anova_list[[id]] <- ezANOVA(
        data = df[df$study_id==study_id, ], 
        dv = .(CR),         
        wid = .(participant_id),
        within = .(phase, condition),
        detailed = TRUE
        )

        output <- capture.output({
            cat("===================\n\n")
            cat("Study ID:", study_id, "\n\n")
            cat("===================\n\n")
            print(rm_anova_list[[id]])
            cat("\n\n")
        })
        all_outputs <- c(all_outputs, output)

        df_ <- tibble(
            study_id = rep(study_id, 3),
            effect = c("phase", "condition", "phase_condition"),
            F = c(
                rm_anova_list[[id]][["ANOVA"]][[2, "F"]],
                rm_anova_list[[id]][["ANOVA"]][[3, "F"]],
                rm_anova_list[[id]][["ANOVA"]][[4, "F"]]
            )
        )
        rm_anova_df <- bind_rows(rm_anova_df, df_)
    }

    # Collect results reported in the paper
    paper_data <- c(
        "01", "phase", "17.1",
        "01", "condition", "3.92",
        "01", "phase_condition", "1.65",
        "02", "phase", "26.8",
        "02", "condition", "17.0",
        "02", "phase_condition", "6.66",
        "03", "phase", "35.72",
        "03", "condition", "17.8",
        "03", "phase_condition", "22.12",
        "04", "phase", "18.19",
        "04", "condition", "17.61",
        "04", "phase_condition", "10.19"
    )

    paper_data <- matrix(paper_data, ncol = 3, byrow = TRUE)
    results_df_paper <- as.data.frame(paper_data)
    colnames(results_df_paper) <- c("study_id", "effect", "F")
    results_df_paper <- as_tibble(results_df_paper)
    

    df <- right_join(rm_anova_df, results_df_paper, by = c("study_id", "effect"))

    df <- df %>%
        rename(
            F = F.x,
            F_paper = F.y
        ) %>%
        mutate(
            F = round(F, 2),
            F_paper = as.numeric(F_paper),
            abs_error = round(abs(F - F_paper), 2)
        )

    out <- list(
        df = df, 
        aov = rm_anova_list, 
        txt = all_outputs
    )
    return(out)
}



