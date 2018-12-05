#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: apply2.R
# Desc: Exemplifying use of apply to run functions.
# Arguments: v <- numeric
# Date: 19 Oct 2018

rm(list=ls())

# for the matrix v, if the sum is greater than 0, return value *100, if not, keep value
SomeOperation <- function(v){
    if (sum(v) > 0){
        return(v * 100)
    }
    return(v)
}

# generates a random matrix of 100 values from a normal distribution
M <- matrix(rnorm(100,10,10))
# print output of function and uses apply to run function
print (apply(M, 1, SomeOperation))