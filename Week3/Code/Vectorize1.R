#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: Vectorize1.R 
# Desc: Exemplifies time taken to use a for loop method and vectorization method 
#       for the same process.
# Arguments: M -> a randomly generated matrix
# Date: 20 Oct 2018

rm(list=ls())

#generate a 1000x1000 matrix of random numbers up to 1million
M <- matrix(runif(100000),1000,1000)

# define a function of the matrix
SumAllElements <- function(M) {
    # set a variable to the same dimensions as the matrix
    Dimensions <- dim(M) 
    # initial value of Tot
    Tot <- 0 
    # for every row in the matrix
    for (i in 1:Dimensions[1]){ 
        # for every column in the matrix
        for (j in 1:Dimensions[2]){ 
            #add each element
            Tot <- Tot + M[i,j] 
        }
    }
    # return the total sum
    return (Tot) 
 }

 # comparison of the time taken using SumAllElements() and sum()
 # longer method as runs a for loop
 print(system.time(SumAllElements(M)))
 # quicker as draws on an inbuilt function (originall a program written C) which 
 # is more primitive and faster to run
 print(system.time(sum(M)))