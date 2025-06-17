require(dplyr)
require(readr)
require(purrr)
require(stringr)

get_data <- function(standata, df_covs) {

    ## Add GP part
    standata[['data_list']][['D']] <- 1
    standata[['data_list']][['x']] <- as.matrix(df_covs[["alpha_scaled"]])
    standata[['data_list']][['x_prime']] <- as.matrix(df_covs[["alpha"]])

    return(standata)
}
