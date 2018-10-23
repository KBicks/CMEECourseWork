# applying functions to rows/columns of a matrix
# using inbuilt function

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