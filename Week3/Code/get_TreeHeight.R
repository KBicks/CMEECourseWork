#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: get_TreeHeight.R
# Desc: Calculates tree height from the angle to top and distance from base, and
#       saves calculated values in csv with original data, takes data file from 
#       command line, and outputs to results.
# Arguments: Input <- csv file, from command line.
# Date: 16 Oct 2018

# set input file to be taken from the command line
Input = commandArgs(trailingOnly = TRUE)

# read input and set to Trees
Trees <- read.csv(Input, header=TRUE)


# for every row in data
for (i in Trees) {
    # calculate angle from top in radians
    radians <- Trees$Angle.degrees * pi /180
    # calculate height of tree using distance and angle calculated above
    height <- Trees$Distance.m * tan(radians)
    # save height in a vector
    Height.m <- c(height)
}

# create data frame of original data and new calculated heights
TreeHeight <- data.frame(Trees, Height.m)
# create output name by taking input name and removing file extension:
# first spliting name at /
Output <- unlist(strsplit(Input, split="/", fixed=TRUE))[-1][-1]
# then substituting .csv for nothing
Output<- gsub(".csv", "", Output)

# save dataframe as output name with _treeheights.csv on end into Results directory
write.csv(TreeHeight,file = paste0("../Results/",Output,"_treeheights.csv"))
