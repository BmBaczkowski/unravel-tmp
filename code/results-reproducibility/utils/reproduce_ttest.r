require(dplyr)

reproduce_ttest <- function(df){
    study_id_list <- unique(df$study_id)

    phase_list <- unique(df$phase)

    ttest_list <- vector("list")
    all_outputs <- c()
    ttest_df <- tibble(
        study_id = character(),
        phase = character(),
        t = numeric()
    )

    for (study_id in study_id_list){

        output <- capture.output({
            cat("===================\n\n")
            cat("Study ID:", study_id, "\n")
            cat("===================\n\n")
        })
        all_outputs <- c(all_outputs, output)
        
        for (phase_id in phase_list){

            id <- sprintf("study-%s_phase-%s", study_id, phase_id)
    
            CR_CSm <- df %>%
                filter(study_id == !!study_id, condition == "CSm", phase == !!phase_id) %>%
                pull(CR)

            CR_CSp <- df %>%
                filter(study_id == !!study_id, condition == "CSp", phase == !!phase_id) %>%
                pull(CR)
            
            ttest_list[[id]] <- t.test(CR_CSp, CR_CSm, paired = TRUE)

            df_ <- tibble(
                study_id = study_id,
                phase = phase_id,
                t = ttest_list[[id]][["statistic"]]
            )
            ttest_df <- bind_rows(ttest_df, df_)

            output <- capture.output({
                cat("Phase ID:", phase_id, "\n\n")
                print(ttest_list[[id]])
                cat("\n\n")
            })
            all_outputs <- c(all_outputs, output)
        }

    }

    # # Collect results reported in the paper
    paper_data <- c(
        "01", "conditioning", "2.31",
        "01", "post_conditioning", "1.82",
        "01", "pre_conditioning", "0.36",
        "02", "conditioning", "4.89",
        "02", "post_conditioning", "3.32",
        "02", "pre_conditioning", "1.28",
        "03", "conditioning", "6.60",
        "03", "post_conditioning", "1.90",
        "03", "pre_conditioning", "0.17",
        "04", "conditioning", "5.75",
        "04", "post_conditioning", "1.71",
        "04", "pre_conditioning", "1.37"
    )

    paper_data <- matrix(paper_data, ncol = 3, byrow = TRUE)
    results_df_paper <- as.data.frame(paper_data)
    colnames(results_df_paper) <- c("study_id", "phase", "t")
    results_df_paper <- as_tibble(results_df_paper)
    

    df <- right_join(ttest_df, results_df_paper, by = c("study_id", "phase"))

    df <- df %>%
        rename(
            t = t.x,
            t_paper = t.y
        ) %>%
        mutate(
            t = round(t, 2),
            t_paper = as.numeric(t_paper),
            abs_error = round(abs(t - t_paper), 2)
        )

    out <- list(
        df = df, 
        ttest = ttest_list, 
        txt = all_outputs
    )

    return(out)
}



