#!/usr/bin/env Rscript

# This is a function to get a proportion
# of the posterior wrt ROPE
# lb -- lower bound
# ub -- upper bound
# Usage

# This function calculates the proportion of the posterior distribution 
# that lies within the Region of Practical Equivalence (ROPE).
#
# Parameters:
# - lb: The lower bound of the ROPE.
# - ub: The upper bound of the ROPE.
#
# Returns:
# - The proportion of the posterior distribution that
# (a) falls within the specified bounds (lb, ub)
# Example: get_p_rope(posterior, lb = -0.1, ub = 0.1)
# (b) or above the specified upper bound
# Example: get_p_rope(posterior, ub = 0.1)
# (c) or below the specified lower bound
# Example: get_p_rope(posterior, lb = 0.1)

get_p_rope <- function(sampleVec, lb = NA, ub = NA){

    if (is.na(lb) & is.na(ub)) {
        return(NA)
    }

    n <- length(sampleVec)
    if (!is.na(lb) & !is.na(ub)) {
        ub_sum <- sum(sampleVec > ub)
        lb_sum <- sum(sampleVec < lb)
        p <- 1 - round((lb_sum + ub_sum) / n, 2)
        return(p)
    }

    if (!is.na(ub)) {
        ub_sum <- sum(sampleVec > ub)
        p <-  round(ub_sum / n, 2)
        return(p)
    }

    if (!is.na(lb)) {
        lb_sum <- sum(sampleVec < lb)
        p <-  round(lb_sum / n, 2)
        return(p)
    }

}
