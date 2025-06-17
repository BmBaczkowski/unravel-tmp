
plot_func <- function(rho_means, rho_hpdi, OR_means, OR_hpdi, rho_betas_rope, ylim=c(0.6, 1.9)) {
    

    par(mar=c(4, 4, 1, 1),  
        mgp=c(3, 0.5, 0),
        tcl=-0.2,
        family='Helvetica',
        ps=12,  # Point size
        cex.axis=1,
        cex.lab=1,
        cex.main=1,  
        font.main=1)

    plot(
        x=.5,
        y=.5, 
        xlim=c(0.5,6.5),
        ylim=ylim,
        xlab="",
        ylab="",
        las=1, 
        type='n',
        yaxt='n',
        xaxt='n',
        bty="l")
    
    title(
        # main=paste("Memory recognition\n(threshold model)"),
        line=1,
        cex.main=1.4,
        font.main=1
        )           


    #yticks
    ys = seq(.1, 2, by=.2)
    # ys = c(.2, .3, .4, .5, .6, .7)
    # ys = sort(c(ys, .54, .57, .49, .64, .41, .47))
    yticks = as.character(ys)
    axis(side=2, at=ys, labels=yticks, las=1, 
        lwd=0, # line width, make 0 it does not overlap with the existing margin
        lwd.ticks=1) # width of the ticks so that they are visable
    title(ylab="Memory recognition (d')", line=2, cex=1.2)

    #xticks
    xs = rep(x=1:3, times=2)
    xticks = as.character(xs)
    axis(side=1, at=1:6, labels=NA, las=1, 
        lwd=0, # line width, make 0 it does not overlap with the existing margin
        lwd.ticks=1) # width of the ticks so that they are visable
    mtext(text=c("condition:", rep(c("CS-", "CS+"), times=3)), at=c(0.2, 1:6), side=1, line=0.5)
    mtext(text=c("phase:", "pre-conditioning", "conditioning", "post-conditioning"), at=c(0.2, 1.5, 3.5, 5.5), side=1, line=1.5)    

    # add legend
    legend("bottomleft", inset=c(0.05, 0.08),
        legend=c("mean [89% HPD: LB, UB]", "mean per phase"),
        pch=c(19, NA), 
        lty=c(1, 2),
        box.lty=0, 
        cex=.8
    )

    # plot the means + HPDI
    for (i in 1:6){
        points(x=i, y=rho_means[i], type='p', cex=1.2, pch=19, col=1)
        segments(x0=i, x1=i, y0=rho_hpdi[1,i], y1=rho_hpdi[2,i], lty=1, lwd=1.5, lend=0, col=1)
    }

    # add means per phase
    xd <- 0.2
    segments(x0=1-xd, x1=2+xd, y0=mean(rho_means[1:2]), y1=mean(rho_means[1:2]), lty=2, lwd=1.5, lend=0, col=1)
    segments(x0=3-xd, x1=4+xd, y0=mean(rho_means[3:4]), y1=mean(rho_means[3:4]), lty=2, lwd=1.5, lend=0, col=1)
    segments(x0=5-xd, x1=6+xd, y0=mean(rho_means[5:6]), y1=mean(rho_means[5:6]), lty=2, lwd=1.5, lend=0, col=1)


    # plot OR
    yv <- 1.65
    yd <- 0.02
    cex_labels <- .9
    segments(x0=1, x1=2, y0=yv, y1=yv, lty=1, lwd=1, lend=0, col=1)
    segments(x0=1, x1=1, y0=yv, y1=yv-yd, lty=1, lwd=1, lend=0, col=1)
    segments(x0=2, x1=2, y0=yv, y1=yv-yd, lty=1, lwd=1, lend=0, col=1)
    text(x=1.5, y=yv + 1.5 * strheight("P"), pos=3, cex = cex_labels, 
        labels = bquote(
        beta[4] == .(round(OR_means[4], 2)) ~ 
        "[" * .(round(OR_hpdi[1,4], 2)) * "," ~ .(round(OR_hpdi[2,4], 2)) * "]")
    )
    text(x=1.5, y=yv, pos=3, labels = paste0("Pr(ROPE) = ", rho_betas_rope[4]), cex = cex_labels)


    segments(x0=3, x1=4, y0=yv, y1=yv, lty=1, lwd=1, lend=0, col=1)
    segments(x0=3, x1=3, y0=yv, y1=yv-yd, lty=1, lwd=1, lend=0, col=1)
    segments(x0=4, x1=4, y0=yv, y1=yv-yd, lty=1, lwd=1, lend=0, col=1)
    text(x=3.5, y=yv + 1.5 * strheight("P"), pos=3, cex = cex_labels,
        labels = bquote(
        beta[5] == .(round(OR_means[5], 2)) ~ 
        "[" * .(round(OR_hpdi[1,5], 2)) * "," ~ .(round(OR_hpdi[2,5], 2)) * "]")
        )
    text(x=3.5, y=yv, pos=3, labels = paste0("Pr(ROPE) = ", rho_betas_rope[5]), cex=cex_labels)


    segments(x0=5, x1=6, y0=yv, y1=yv, lty=1, lwd=1, lend=0, col=1)
    segments(x0=5, x1=5, y0=yv, y1=yv-yd, lty=1, lwd=1, lend=0, col=1)
    segments(x0=6, x1=6, y0=yv, y1=yv-yd, lty=1, lwd=1, lend=0, col=1)
    text(x=5.5, y=yv + 1.5 * strheight("P"), pos=3, cex = cex_labels,
        labels = bquote(
        beta[6] == .(round(OR_means[6], 2)) ~ 
        "[" * .(round(OR_hpdi[1,6], 2)) * "," ~ .(round(OR_hpdi[2,6], 2)) * "]")
    )
    text(x=5.5, y=yv, pos=3, labels = paste0("Pr(ROPE) = ", rho_betas_rope[6]), cex=cex_labels)

}

