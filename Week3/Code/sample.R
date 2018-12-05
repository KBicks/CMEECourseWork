#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: sample.R 
# Desc: Exemplifies generating a vector of 100 random values using a function and
#       the command 'sample()', then how to run function using vectorization or a 
#       for loop. 
# Arguments: none
# Date: 15 Oct 2018

rm(list=ls())

## run a simulation that involves sampling from a population

# generate ramdom population
x <- rnorm(50)
# create a function of x called "doit"
doit <- function(x) {
    # take a sample of x of the same size of x and replace current values
    x <- sample(x, replace = TRUE)
    # if the number of unique numbers in x is more than 30
    # checks sample size is sufficient
    if(length(unique(x)) > 30) { 
        # prints the mean 
        print(paste("Mean of this sample was:", as.character(mean(x))))
        }
} 

# test the function by running 100 iterations - using vectorization
result <- lapply(1:100, function(i) doit(x))

# can also calculate results using a for loop:
# preallocate format of result to a vector length 100
result <- vector("list", 100)
# for every value from 1-100, fill the vector with results calculated by the
# function doit
for(i in 1:100){
    result[[i]] <- doit(x)
}
