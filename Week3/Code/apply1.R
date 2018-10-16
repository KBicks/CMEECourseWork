# applying same function to rows/columns of a matrix

M <- matrix(rnorm(100),10,10) # generate random matrix of 10x10

# Taking mean of each row of M
RowMeans <- apply(M, 1, mean)
print(RowMeans)

# Calculating variance of each row
RowVars <- apply(M, 1, var)
print(RowVars)

# Taking mean of each column
ColMeans <- apply(M, 2, mean)
print (ColMeans)