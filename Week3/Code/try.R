#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: try.R
# Desc: Compares vectorization and for loops to run simulation using 'try', with
#       specified error message.
# Arguments: x <- vector
# Date: 21 Oct 2018

rm(list=ls())## run a simulation that involves sampling from a population

x <- rnorm(50) #generate your population
doit <- function(x) {
    x <- sample(x, replace = TRUE)
    if(length(unique(x)) > 30) { #only take mean if sample was sufficient
        print(paste("Mean of this sample was:", as.character(mean(x))))
        }
    else { 
        # stop generates the specified error message
        stop("Couldn't calculate mean: too few unique points!")
    }
} 

## Run 100 iterations using vectorization with try:
result <- lapply(1:100, function(i) try(doit(x), FALSE))

## Or using a for loop:
result <- vector("list", 100) #preallocate/initialise
for(i in 1:100){
    # false in function prevents error messages from being surpressed
    result[[i]] <- try(doit(x),FALSE)
}