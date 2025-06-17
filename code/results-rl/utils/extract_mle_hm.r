require(dplyr)
require(readr)


extract_mle <- function(stanfit) {

    samples <- stanfit$par
    parnames <- names(samples)

    pattern <- "^alpha\\[\\d+\\]"
    indx <- grep(pattern, parnames)
    alpha <- samples[indx]

    pattern <- "^eta_init\\[\\d+\\]"
    indx <- grep(pattern, parnames)
    eta_init <- samples[indx]

    df <- tibble(
        alpha = round(alpha, 2),
        eta_init = round(eta_init, 2)
    )

    return(df)
}
