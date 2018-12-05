#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: break.R
# Desc: Exemplifying use of 'break' in while, if and else statements.
# Arguments: i <- numeric 
# Date: 15 Oct 2018

rm(list=ls())

# set initial value of i
i <- 0 
# while i is less than infinity
    while(i<Inf) {
        # when i is 20
        if (i==20) {
            # break while loop
            break } 
        # if i is not 20
        else { 
            # print the value of i and start a new line
            cat("i equals " , i, "\n")
            # increase value of i by 1 each loop
            i <- i+1 
        }
    }