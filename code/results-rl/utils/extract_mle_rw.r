require(dplyr)
require(readr)


extract_mle <- function(stanfit) {

    samples <- stanfit$par
    parnames <- names(samples)
    pattern <- "^alpha\\[\\d+\\]"
    indx <- grep(pattern, parnames)

    output <- samples[indx]

    df <- tibble(
        alpha = round(output, 2)
    )

    return(df)
}
