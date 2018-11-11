#!/usr/bin/env Rscript
# Author: Katie Bickerton <k.bickerton18@imperial.ac.uk>
# Desc: Illustrates R input-output
# Date: Oct 2018

# Run line by line and check inputs outputs to understand what is happening

# Import csv file with headers
MyData = read.csv("../Data/trees.csv", header = TRUE)
# Write input out as a new file called MyData
write.csv(MyData, "../Results/MyData.csv") 
# Append csv file
write.table(MyData[1,], file = "../Results/MyData.csv",append=TRUE)
# write csv with row names
write.csv(MyData, "../Results/MyData.csv", row.names=TRUE)
# write csv and ignore column names
write.csv(MyData, "../Results/MyData.csv", col.names=FALSE) 