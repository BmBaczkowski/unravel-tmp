#!/usr/bin/env Rscript

# This code comes from Alexander Etz et al. (2024), originally published at:
# https://doi.org/10.1037/met0000660
# Licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0)
# (https://creativecommons.org/licenses/by/4.0/)
# 
# Modifications:
# - None

QIofMCMC <- function(sampleVec, credMass=0.95){
    # Computes the quantile interval from 
    # (1-credMass)/2 to 1-(1-credMass)/2, where 
    # credMass is the target percentage of 
    # posterior samples to be included in the interval.
    # The typical value credMass =0.95 results in 
    # an interval from the 2.5% to the 97.5% quantile.
    alp <- (1-credMass)/2
    lim <- quantile(sampleVec, probs=c(alp,1-alp))
    return(lim)
}