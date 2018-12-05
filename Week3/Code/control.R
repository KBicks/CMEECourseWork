#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: control.R 
# Desc: Demonstrating use of control flows, using if, else and while statements,
#       and for loops.
# Arguments: none
# Date: Oct 2018

rm(list=ls())

## If statement example
# initial value of a set
a <- TRUE
# if a is true
if (a == TRUE) {
   # print to terminal
   print ("a is TRUE")
   # if not true
} else {
    # print to terminal
print ("a is FALSE")
}

# set z to a value from a random distribution between 0-1
z <- runif(1)
# if z is less than or equal to 0.5
if (z <= 0.5) {
    # print the below message
    print ("Less than a quarter")
}

## For loop using a sequence
# for every value between 1-100
for (i in 1:100) {
    # set j equal to the square of the value of i
    j <- i * i
    # print the statement below
    print(paste(i, " squared is", j))
}

## For loop over vector of strings
# for every species in the vector of strings
for(species in c('Heliodoxa rubinoides',
                 'Boissonneaua jardini',
                 'Sula nebouxii'))
{
    # print the statement below:
    print(paste('The species is', species))
}

## For loop using a vector
# set v1 to a vector of strings
v1 <- c("a","bc","def")
# for every value of the vector v1
for (i in v1) {
    # print the value of v1
    print(i)
}

## While loop
# set initial value of i
i <- 0
# while i is less than 100
while(i<100) {
    # reset value of i to i+1 (next step up)
    i <- i+1
    # print the value of i squared
    print(i^2)
}