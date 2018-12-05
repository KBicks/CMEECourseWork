#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: Preallocate.R
# Desc: Comparing the effect if preallocation of variables on run time.
# Arguments: a -> numeric
# Date: 20 Oct 2018

rm(list=ls())

# two methods for allocating values to a vector
# both create a vector of NAs, length 100000 - which populates as function runs

# initial value of a set as NA - generates one value at a time
a <- NA
NotPreallocated <- function(a){
    for (i in 1:100000){
        # adds each individual element to a vector
        a <- c(a,i)
    }
}

# starts with dimensions of a given and structure already created, then replaces each NA
# quicker option
a <- rep(NA,10000) 
Preallocated <- function(a){
    for (i in 1:100000){
        # fills predefined vector
        a[i] <- i
    }
}

# check times taken by both options
print(system.time(NotPreallocated(a)))
print(system.time(Preallocated(a)))