#!/usr/bin/env Rscript
# Author: Katie Bickerton <k.bickerton18@imperial.ac.uk>
# Desc: exemplifies use of inbuilt functions in R and application to rows and columns
# Date: Oct 2018

# applying functions to rows/columns of a matrix
# using inbuilt functions

M <- matrix(rnorm(100),10,10) # generate random matrix of 10x10

# Taking mean of each row of M
RowMeans <- apply(M, 1, mean) #M gives the matrix, 1 specifies by row
print(RowMeans)

# Calculating variance of each row
RowVars <- apply(M, 1, var)
print(RowVars)

# Taking mean of each column
ColMeans <- apply(M, 2, mean) # 2 specifies by column
print (ColMeans)