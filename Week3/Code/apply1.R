#!/usr/bin/env Rscript
# Author: Katie Bickerton <k.bickerton18@imperial.ac.uk>
# Script: apply1.R
# Desc: Exemplifies use of apply function in R and application 
#       to rows and columns.
# Arguments: M <- matrix
# Date: 19 Oct 2018

rm(list=ls())

# Using the apply function to manipulate an array

# generate random matrix of 10x10
M <- matrix(rnorm(100),10,10) 

# Taking mean of each row of M
#M gives the matrix, 1 specifies by row
RowMeans <- apply(M, 1, mean) 
print(RowMeans)

# Calculating variance of each row
RowVars <- apply(M, 1, var)
print(RowVars)

# Taking mean of each column
ColMeans <- apply(M, 2, mean) # 2 specifies by column
print (ColMeans)