#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: next.R 
# Desc: Exemplifying use of 'next' in a for loop, with an if statement.
# Arguments: i <- numeric
# Date: 15 Oct 2018

# for i in the range 1-10
for (i in 1:10) {
    # if i is a multiple of 2
    if((i %% 2) == 0)
    # start next run of the loop
        next 
    # if not true, print the value of i
    print(i)
}
# with these parameters, outputs a list of odd numbers between 1 and 10