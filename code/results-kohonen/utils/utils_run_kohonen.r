require(kohonen)

get_som <- function(stanfit, mdl_type) {

    if (mdl_type == "SDT") {
        par <- "dprime"
    } else {
        par <- "rho"
    }

    samples <- as.matrix(stanfit)
    parnames <- colnames(samples)

    U <- matrix(ncol=285, nrow=6)
    W <- matrix(ncol=285, nrow=6)
    for (i in 1:6) {
        pattern <- sprintf("mu_beta_%s[%d]", par, i) 
        bar <- samples[, pattern]
        for (j in 1:285) {
            pattern <- sprintf("u_beta_%s[%d,%d]", par, i, j) 
            foo <- samples[, pattern]
            U[i, j] <- mean(foo)
            W[i, j] <- mean(foo + bar)
        }
    }
    U_t <- t(U)
    W_t <- t(W)

    # For better Kohonen visualization
    if (mdl_type == "1HT") {
        set.seed(2345)  
    } else if (mdl_type == "2HT") {
        set.seed(4567)
    } else if (mdl_type == "SDT") {
        set.seed(1234)
    }
    som_grid <- somgrid(xdim = 8, ydim = 7, topo = "hexagonal", toroidal=FALSE)
    som_model <- som(X = scale(W_t), grid = som_grid, rlen = 5e+3)
 
    return(list(som_model=som_model, U_t=U_t, W_t=W_t))
}






