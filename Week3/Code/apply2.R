#!/usr/bin/env Rscript
# Author: Katie Bickerton <k.bickerton18@imperial.ac.uk>
# Desc: Defining own functions, then using apply to run.
# Date: Oct 2018


# for the matrix v, if the sum is greater than 0, return value *100, if not, keep value
SomeOperation <- function(v){
    if (sum(v) > 0){
        return(v * 100)
    }
    return(v)
}

# generates a random matrix of 100 values from a normal distribution
M <- matrix(rnorm(100,10,10))
# print output of function
print (apply(M, 1, SomeOperation))