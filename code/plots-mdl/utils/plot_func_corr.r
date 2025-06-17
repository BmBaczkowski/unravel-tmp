require(RColorBrewer)

plot_func <- function(R_mat, R_mat_lb, R_mat_ub) {
    lower_tri <- lower.tri(R_mat)
    indices <- which(lower_tri, arr.ind = TRUE)

    R_mat[upper.tri(R_mat)] <- NA
    tf <- function(m) t(m)[, nrow(m):1]
    R_mat_ <- tf(R_mat)
    R_mat_lb_ <- tf(R_mat_lb)
    R_mat_ub_ <- tf(R_mat_ub)


    col_palette <- colorRampPalette(c("#01665e", "#f5f5f5", "#8c510a"))(9) 
    # col_palette <- colorRampPalette(c("#542788", "#f7f7f7", "#b35806"))(9) 

    par(pty = "s")  # Force square plot
    par(mar = c(4, 2, 1, 1)) 

    image(
        R_mat_, 
        axes = FALSE, 
        col=col_palette, 
        xlab = NA, 
        ylab = NA
        )

    title(
        # main= expression("Within-subject correlations (" * beta * ")"),
        # main = bquote("Within-subject correlations\n in memory recognition"),
        line=2,
        cex.main=1,
        font.main=1
    )

    axis(1, 
        at = seq(0, 1, length.out = 6), 
        labels = c(
            expression(beta[1]),
            expression(beta[2]),
            expression(beta[3]),
            expression(beta[4]),
            expression(beta[5]),
            NA #expression(beta[6])
        ), 
        tick = FALSE
    )
    axis(2, 
        at = rev(seq(0, 1, length.out = 6)), 
        labels = c(
            NA, #expression(beta[1]),
            expression(beta[2]),
            expression(beta[3]),
            expression(beta[4]),
            expression(beta[5]),
            expression(beta[6])
        ),
        tick = FALSE, 
        las = 1) 

    # Loop through rows and columns to position text (only lower triangle)
    unit <- 1/5
    for (k in 1:nrow(indices)) {
        i <- indices[k, 1]
        j <- indices[k, 2]
        text(
            x = unit*j - unit,
            y = unit*(7-i) - unit + unit/5, 
            labels = R_mat[i, j], 
            cex = .9, col = "black"
        )
        text(
            x = unit*j - unit,
            y = unit*(7-i) - unit - unit/5, 
            labels = paste0("[", R_mat_lb[i, j], ", ", R_mat_ub[i, j], "]"),
            # labels = paste0("[", i, ", ", j, "]"),
            cex = 0.6, col = "black"
        )
    }


    legend(x = 0.3, y=1.1,
       legend = c(
        expression(beta[1]~":="~"grand mean"),
        expression(beta[2]~":="~Delta~"phase2-phase1"),
        expression(beta[3]~":="~Delta~"phase3-phase2"),
        expression(beta[4]~":="~Delta~"pre-conditioning"),
        expression(beta[5]~":="~Delta~"conditioning"),
        expression(beta[6]~":="~Delta~"post-conditioning")
        ), 
        cex = .8,
        bty = "n",  # No box around the legend
        xpd = FALSE)  # Allow legend to be drawn outside the plot area

}

