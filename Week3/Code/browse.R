#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: browse.R
# Desc: Exemplifying browser() function to debug R code.
# Arguments: N <- vector
# Date: 18 Oct 2018

rm(list=ls())

Exponential <- function(N0 = 1, r=1, generations = 10) {
    #run a simulation of exponential growth
    #returns a vector of lengths of generations

    N <- rep(NA, generations)

    #set starting population
    N[1] <- N0
    # start from second to end generations
    for (t in 2:generations) {
        #equation for exponential growth
       N[t] <- N[t-1] * exp(r)
       #enable debugging through browser
       browser()
    }
    return (N)
}
#plot of exponential population growth
plot(Exponential(), type = "l", main = "Exponential growth")