
plot_mcmc_chains <- function(samples, param_name, prob = .89) {

    n_chains <- length(samples)

    # ESS
    res <- effectiveSize(samples[, param_name])
    ESS <- res[["var1"]]

    # R hat
    res <- gelman.diag(samples[, param_name])
    # Print the Rhat and upper confidence interval values
    r_hat <- res$psrf[1]
    r_hat_uci <- res$psrf[2]

    # Posterior 
    posterior <- unlist(samples[, param_name])
    p_min <- min(posterior)
    p_max <- max(posterior)
    n_iter <- nrow(samples[[1]])

    #par(mfrow = c(1, 2))
    # Set up the layout matrix
    n <- n_chains 
    col1 <- rep(1, n)
    col2 <- seq(2, n+1)
    layout_matrix <- cbind(col1, col2)
    colnames(layout_matrix) <- NULL

    # Apply the layout
    layout(layout_matrix)
    col_code <- c("gold", "cyan3", "magenta3", "springgreen3")

    # Plot 1: posterior dist
    dens <- density(posterior, adjust = 0.5)
    max_density <- max(dens$y)
    max_density_x <- dens$x[which.max(dens$y)]
    hpd <- HPDinterval(as.mcmc(posterior), prob = prob)
    plot(
        dens, 
        xlab = param_name,
        ylab = "Density",
        type = "l",
        main = "Density"
    )
    # Add ESS
    legend("topleft", c(
        sprintf("ESS: %.0f", ESS), 
        sprintf("Rhat: %.3f", r_hat),
        sprintf("Upper CI: %.3f", r_hat_uci),
        sprintf("Mode: %.3f", max_density_x)
        ), cex=1, box.lty=0)
    
    # Add HPD interval
    segments(hpd[1], 0, hpd[2], 0, col = "black", lwd = 2)

    # Add text labels for HPD interval endpoints
    text(mean(hpd), 0, sprintf("%i%% HPDI", prob*100), pos = 3, offset = 0.5, col = "black")
    text(hpd[1], 0, sprintf("%.3f", round(hpd[1], 3)), pos = 1, offset = 0.5, col = "black")
    text(hpd[2], 0, sprintf("%.3f", round(hpd[2], 3)), pos = 1, offset = 0.5, col = "black")


    # Plot: Chains
    for (i in 1:n_chains) {
        vals <-  samples[, param_name][[i]]
        plot(
            1:n_iter, vals, 
            type = "l", 
            lwd = 1,
            lty = 1,
            col = "grey",
            xlab = "", 
            ylab = "",
            axes = FALSE,
            ann = FALSE
            #xlim = c(0, n_iter + 1),
            # ylim = c(p_min, p_max)
            #main = "Trace"
        )
        axis(1, tick = FALSE)  # Adding the x-axis without ticks
        axis(2, tick = FALSE, labels=FALSE)  # Adding the y-axis without ticks
        box() 
    }
}





