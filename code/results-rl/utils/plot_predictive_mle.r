
plot_func <- function(samples, data, target_file) {
    df <- data[['df']]
    y <- df %>%
        mutate(
            bin = rep(rep(1:3, each = 10), times=max(subject_id))
        ) %>%
        group_by(
            subject_id, bin
        ) %>%
        summarize(
            response_csp_prop = sum(response_csp) / 10,
            response_csm_prop = sum(response_csm) / 10,
            .groups = 'drop'
        )

    subject_id <- df[['subject_id']]
    bin_id <- rep(rep(1:3, each = 10), times=max(subject_id))
    y_csp <- y[['response_csp_prop']]
    y_csm <- y[['response_csm_prop']]
    bin_id_agr <- y[['bin']]
    subject_id_agr <- rep(1:285, each=3)

    response_csm_pred <- samples$response_csm_pred
    y_csm_pred <- matrix(nrow=2000, ncol=285*3)
    for (i in 1:3){
        for (j in 1:285){
            y_csm_pred[,subject_id_agr==j & bin_id_agr==i] =  apply(
                response_csm_pred[, bin_id==i & subject_id==j], 1, sum)
        }
    }
    y_csm_pred <- y_csm_pred / 10
    
    response_csp_pred <- samples$response_csp_pred
    y_csp_pred <- matrix(nrow=2000, ncol=285*3)
    for (i in 1:3){
        for (j in 1:285){
            y_csp_pred[,subject_id_agr==j & bin_id_agr==i] =  apply(
                response_csp_pred[, bin_id==i & subject_id==j], 1, sum)
        }
    }
    y_csp_pred <- y_csp_pred / 10

    pdf(file = target_file, width = 7, height = 5)  # Width and height are in inches
        outplot <- ppc_stat_grouped(
            y_csp, 
            y_csp_pred, 
            group = bin_id_agr,
            stat = 'mean',
            bins = 50
            ) + labs(title="CSp")
        print(outplot)
        outplot <- ppc_stat(
            y_csp, 
            y_csp_pred, 
            stat = 'mean',
            bins = 50
            ) + labs(title="CSp")
        print(outplot)
        outplot <- ppc_stat_grouped(
            y_csm, 
            y_csm_pred, 
            group = bin_id_agr,
            stat = 'mean',
            bins = 50
            ) + labs(title="CSm")
        print(outplot)
        outplot <- ppc_stat(
            y_csm, 
            y_csm_pred, 
            stat = 'mean',
            bins = 50
            ) + labs(title="CSm")
        print(outplot)
    dev.off()
}
