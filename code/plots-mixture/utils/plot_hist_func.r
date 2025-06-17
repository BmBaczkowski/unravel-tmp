
plot_func <- function(phi, phi_mean, phi_hpdi) {

    par(mar=c(1, 1, 1, 0.5))
    par(mgp=c(0, 0, 0))

    # Plot histogram without axes and in black
    hist(phi, 
        freq = FALSE,
        breaks = 30,
        col = "grey",    
        border = "grey", 
        axes = FALSE,    
        main = bquote("Base rate" ~ "(" * phi * ")"), 
        xlab = NA, 
        ylab = NA)
    axis(1)

    # Define your segment coordinates
    x0 <- phi_hpdi[1]
    x1 <- phi_hpdi[2]
    y <- 0.1  # y position of the segment

    # Plot the segment
    segments(x0 = x0, x1 = x1, y0 = y, y1 = y, col = "black", lwd = 1)

    # Add text above the segment
    text(x = (x0 + x1) / 2,          
        y = y + 0.3,          
        labels = "89% HPD",  
        col = "black")
}