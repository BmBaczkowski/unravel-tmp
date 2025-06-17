
plot_func <- function(mle_fit, data, target_file) {
    mle_params <- mle_fit$par
    parnames <- names(mle_params)

    # yes, I know its not good when values are hard coded
    V_CSp <- matrix(nrow=285, ncol=30)
    V_CSm <- matrix(nrow=285, ncol=30)
    eta_CSp <- matrix(nrow=285, ncol=30)
    eta_CSm <- matrix(nrow=285, ncol=30)

    hm = FALSE
    if (sum(grepl("eta", parnames)) > 0){
        hm = TRUE
    }

    for (i in 1:30){
        pattern <- paste0("^V_CSp\\[\\d+,", i, "\\]")
        indx <- grep(pattern, parnames)
        V_CSp[,i] <- as.vector(mle_params[indx])

        pattern <- paste0("^V_CSm\\[\\d+,", i, "\\]")
        indx <- grep(pattern, parnames)
        V_CSm[,i] <- as.vector(mle_params[indx])

        if (hm) {
            pattern <- paste0("^eta_CSp\\[\\d+,", i, "\\]")
            indx <- grep(pattern, parnames)
            eta_CSp[,i] <- as.vector(mle_params[indx])

            pattern <- paste0("^eta_CSm\\[\\d+,", i, "\\]")
            indx <- grep(pattern, parnames)
            eta_CSm[,i] <- as.vector(mle_params[indx])

            pattern <- paste0("^eta_init_hat\\[\\d+\\]")
            indx <- grep(pattern, parnames)
            eta_init <- as.vector(mle_params[indx])
        }

    }
    pdf(file = target_file, width = 7, height = 5)  # Width and height are in inches
    # plot(1, 1, type='n', xlim=c(0,31), ylim=c(0,1))
    matplot(
        x=0:29, 
        y=t(V_CSm),
        xlim=c(0,31), 
        ylim=c(0,1),
        col= rgb(0.2, 0.2, 0.2, alpha = 0.3),
        type='l',
        lty = 1
    )
    points(x=0:29, colMeans(V_CSm), pch=21, col='blue')
    matplot(
        x=0:29, 
        y=t(V_CSp),
        xlim=c(0,31), 
        ylim=c(0,1),
        col= rgb(0.2, 0.2, 0.2, alpha = 0.3),
        type='l',
        lty = 1
    )
    points(x=0:29, colMeans(V_CSp), pch=21, col='blue')
    if (hm){
        matplot(
            x=0:30, 
            y=rbind(eta_init, t(eta_CSp)),
            xlim=c(0,31), 
            ylim=c(0,1),
            col= rgb(0.2, 0.2, 0.2, alpha = 0.3),
            type='l',
            lty = 1
        )
        points(x=1:30, colMeans(eta_CSp), pch=21, col='blue')
        matplot(
            x=0:30, 
            y=rbind(eta_init, t(eta_CSm)),
            xlim=c(0,31), 
            ylim=c(0,1),
            col= rgb(0.2, 0.2, 0.2, alpha = 0.3),
            type='l',
            lty = 1
        )
        points(x=1:30, colMeans(eta_CSm), pch=21, col='blue')
    }
    dev.off()
}
