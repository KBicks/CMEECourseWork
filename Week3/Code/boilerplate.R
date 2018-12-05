#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: boilerplate.R
# Desc: A boilerplate script exemplifying printing arguments and their type in R.
# Arguments: Arg1, Arg2 -> no restrictions on type.
# Date: 15 Oct 2018

rm(list=ls())

# A boilerplate R script

# Make a function called 'MyFunction' which required 2 arguments
MyFunction <- function(Arg1,Arg2) {
    # prints each arguments and specifies type of argument
    print(paste("Argument", as.character(Arg1), "is a", class(Arg1))) #print Arg1's type
    print(paste("Argument", as.character(Arg2), "is a", class(Arg2))) #print Arg2's type
    # returns a vector of the input arguments
    return (c(Arg1,Arg2))
}

#testing function, first should return type as numeric, second as characters
MyFunction(3,18)
MyFunction("Riki","Tiki")