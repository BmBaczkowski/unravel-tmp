#!/usr/local/bin/R

cex_axis = 1
cex_lab = 1.1
cex_main = 1.2
cex_points = 1.5
cex_labels = 0.8
cex_legend = 0.8
colors = c('#a6cee3', '#1f78b4', '#b2df8a', '#33a02c')

subplot1 <- function(df) {
    plot(
        x=50, 
        y=50, 
        xlim=c(20, 80), 
        ylim=c(20, 80), 
        type="n", 
        las=1, 
        cex.axis=cex_axis,
        cex.lab=cex_lab,
        ylab="reproduced [%]", 
        xlab="reported [%]", 
        bty="l")
    
    title(
        main="Overall performance",
        cex.main=cex_main,
        font.main=1
        )

    # subscript for the figure
    mtext("a)", side=3, line=1.8, adj=-.30, cex=1, col="black", outer=FALSE)

    # identity line
    abline(a = 0, b = 1, col = "black", lwd = 1, lty = 5)

    pch_type <- df %>%
        mutate(
            pch_type = case_when(
                performance == "false_alarm_rate" ~ 21, 
                performance == "hit_rate" ~ 22
            )
        ) %>%
        pull(pch_type)

    # performance
    points(
        x=df[['avg_paper']],
        y=df[['avg']],
        pch=pch_type,
        bg=rgb(0, 0, 0, .2),
        col='black',
        cex=cex_points
    )

    text(x=df[['avg_paper']],
        y=df[['avg']], 
        labels = as.integer(df[['study_id']]),
        cex = cex_labels, 
        pos = 2, 
        col = "black")

    legend("topleft",                    
       legend = c("Hit rate", "False alarm rate"),               
        col = 'black',
        pt.bg = 'grey',
        pch = c(22, 21), 
        cex=cex_legend,                    
        title = "Performance",
        bty = "n")                
}


subplot2 <- function(df) {
    plot(
        x=50, 
        y=50, 
        xlim=c(0, 7), 
        ylim=c(0, 7), 
        type="n", 
        las=1, 
        cex.axis=cex_axis,
        cex.lab=cex_lab,
        ylab="reproduced [t-value]", 
        xlab="reported [t-value]", 
        bty="l")
    
    title(
        main="Paired t-test \n (corrected recognition)",
        cex.main=cex_main,
        font.main=1
        )

    # subscript for the figure
    mtext("b)", side=3, line=1.8, adj=-.30, cex=1, col="black", outer=FALSE)

    # identity line
    abline(a = 0, b = 1, col = "black", lwd = 1, lty = 5)

    pch_type <- df %>%
        mutate(
            pch_type = case_when(
                phase == "conditioning" ~ 22, 
                phase == "post_conditioning" ~ 23,
                phase == "pre_conditioning" ~ 21
            )
        ) %>%
        pull(pch_type)

    # performance
    points(
        x=df[['t_paper']],
        y=df[['t']],
        pch=pch_type,
        bg=rgb(0, 0, 0, .2),
        col='black',
        cex=cex_points
    )

    text(x=df[['t_paper']],
        y=df[['t']], 
        labels = as.integer(df[['study_id']]),
        cex = cex_labels, 
        pos = 2, 
        col = "black")


    legend("topleft",                    
       legend = c("pre-conditioning", "conditioning", "post-conditioning"),               
        col = 'black',
        pt.bg = 'grey',
        pch = c(21, 22, 23), 
        cex= cex_legend,                    
        title = "Phase",
        bty = "n")                
}


subplot3 <- function(df) {
    plot(
        x=50, 
        y=50, 
        xlim=c(0, 36), 
        ylim=c(0, 36), 
        type="n", 
        las=1, 
        cex.axis=cex_axis,
        cex.lab=cex_lab,
        ylab="reproduced [F-value]", 
        xlab="reported [F-value]", 
        bty="l")
    
    title(
        main="Repeated measure ANOVA\n(corrected recognition)",
        cex.main=cex_main,
        font.main=1
        )

    # subscript for the figure
    mtext("c)", side=3, line=1.8, adj=-.30, cex=1, col="black", outer=FALSE)

    # identity line
    abline(a = 0, b = 1, col = "black", lwd = 1, lty = 5)

    pch_type <- df %>%
        mutate(
            pch_type = case_when(
                effect == "phase" ~ 21, 
                effect == "condition" ~ 22,
                effect == "phase_condition" ~ 23
            )
        ) %>%
        pull(pch_type)

    # performance
    points(
        x=df[['F_paper']],
        y=df[['F']],
        pch=pch_type,
        bg=rgb(0, 0, 0, .2),
        col='black',
        cex=cex_points
    )

    text(x=df[['F_paper']] - seq(0, 1.5, length.out=length(pch_type)),
        y=df[['F']],
        adj = c(0.5, 0.5),
        labels = as.integer(df[['study_id']]),
        cex = cex_labels, 
        pos = 2, 
        col = "black")


    legend("topleft",                    
       legend = c("phase", "condition", "phase x condition"),               
        col = 'black',
        pt.bg = 'grey',
        pch = c(21, 22, 23), 
        cex= cex_legend,                    
        title = "Effect",
        bty = "n")                
}
