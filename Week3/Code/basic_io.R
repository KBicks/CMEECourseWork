#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: basic_io.R
# Desc: Demonstrating input and output of csv files, including appending.
# Arguments: none
# Date: 15 Oct 2018

rm(list=ls())

# Import csv file with headers
MyData = read.csv("../Data/trees.csv", header = TRUE)
# Write input as a new file called MyData, and output to Results directory
write.csv(MyData, "../Results/MyData.csv") 
# Append csv file, also need to ignore column names when appending
# by default col.names is TRUE, leading to appending headings as well as data
write.table(MyData[1,], file = "../Results/MyData.csv",append=TRUE,col.names=FALSE)
# write csv with row names
write.csv(MyData, "../Results/MyData.csv", row.names=TRUE)