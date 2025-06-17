require(RColorBrewer)

plot_func <- function(f, f_ub, f_lb, x_scaled, x, p_rope, ylab, title, gradient_colors, rope_bound) {

    if (ncol(x_scaled) == 2){

        # fit a straight line to two scr features
        mdl <- lm(x_scaled[,2] ~ x_scaled[,1])
        x_line <- coef(mdl)[1] + coef(mdl)[2] * x_scaled[,1]
        x_scaled <- x_line
        # keep only unique values
        duplicates <- !duplicated(x_scaled)
        x_scaled <- x_scaled[duplicates]
        x <- x[duplicates, 2]
        p_rope <- p_rope[duplicates]
        f <- f[duplicates]
        f_lb <- f_lb[duplicates]
        f_ub <- f_ub[duplicates]

        # sort for plotting
        indx <- order(x_scaled)
        x_scaled <- x_scaled[indx]
        x <- x[indx]
        # choose z score for scale
        # x <- x_scaled
        f <- f[indx]
        f_lb <- f_lb[indx]
        f_ub <- f_ub[indx]
        p_rope <- p_rope[indx]

        # smooth for visualisation
        spar <- .7
        f <- smooth.spline(x_scaled, f, spar=spar)$y
        f_ub <- smooth.spline(x_scaled, f_ub, spar=spar)$y
        f_lb <- smooth.spline(x_scaled, f_lb, spar=spar)$y

        # add tick labels 
        xlabs <- round(seq(from=min(x), to=max(x), length.out=4), 2)
        xlabspos <- seq(from=min(x_scaled), to=max(x_scaled), length.out=4)

        xlab <- expression(Delta ~ "SCR [TTP]")

    } else{

        # keep only unique values
        duplicates <- !duplicated(x_scaled)
        x_scaled <- x_scaled[duplicates]
        x <- x[duplicates]
        p_rope <- p_rope[duplicates]
        f <- f[duplicates]
        f_lb <- f_lb[duplicates]
        f_ub <- f_ub[duplicates]

        # sort for plotting
        indx <- order(x_scaled)
        x_scaled <- x_scaled[indx]
        x <- plogis(x[indx])
        f <- f[indx]
        f_lb <- f_lb[indx]
        f_ub <- f_ub[indx]
        p_rope <- p_rope[indx]

        # smooth for visualisation
        spar <- 0.6
        f <- smooth.spline(x_scaled, f, spar=spar)$y
        f_ub <- smooth.spline(x_scaled, f_ub, spar=spar)$y
        f_lb <- smooth.spline(x_scaled, f_lb, spar=spar)$y

        # add tick labels 
        xlabs <- round(seq(from=min(x), to=max(x), length.out=4), 2)
        xlabspos <- seq(from=min(x_scaled), to=max(x_scaled), length.out=4)

        xlab <- 'learning rate'
    }

    # colors
    breaks <- seq(0, 1, by=.01)
    colors <- gradient_colors[as.numeric(cut(p_rope, breaks = breaks, include.lowest=TRUE))]


    print(par('pin'))
    print(par('plt'))
    par(pin = c(1.3, .8))
    yd <- .1
    plot(
        x=mean(x_scaled),
        y=0, 
        xlim=c(min(x_scaled), max(x_scaled)),
        ylim=c(min(f_lb)-yd, max(f_ub)+yd),
        main=NA, 
        xlab=NA,
        # xlab=expression("learning rate" ~ alpha),
        ylab=ylab,
        cex.lab=1,
        las=1, 
        type='n',
        pty='m',
        # asp=.1,
        # yaxt='n',
        xaxt='n',
        bty="l",
        tcl = -.25
    )

    title(main=title, line=0.5, cex.main=1)
    lines(x_scaled, f, col = "black", lty=1, lwd=1.5)  
    lines(x_scaled, f_lb, col = "black", lty=2, lwd=1.5)  
    lines(x_scaled, f_ub, col = "black", lty=2, lwd=1.5)  
    axis(1, at = xlabspos, labels = xlabs, cex.axis=1, line=0)
    mtext(xlab, side = 1, line = 1.5, cex=.6)  

    abline(h=rope_bound, lty=3)
    abline(h=-rope_bound, lty=3)

    points(x_scaled, rep(min(f_lb), length(x_scaled)) - yd, pch=15, col=colors) 

}

