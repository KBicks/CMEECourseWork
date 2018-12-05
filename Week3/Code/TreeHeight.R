#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: TreeHeight.R
# Desc: Calculates tree height from the angle to top and distance from base, and
#       saves calculated values in csv with original data.
# Arguments: degrees -> angle in radians from top, distance -> distance to base of tree
# Date: 15 Oct 2018

rm(list=ls())

# Script to calculate tree height from distance to base and angle to top

# Equation for calculation:
# height = distance * tan(radians)

# Output
# The heights of the tree, same units as distance

# load csv file containing arguments needed
Trees <- read.csv("../Data/trees.csv", header=TRUE)

# for every row in data
for (i in Trees) {
    # calculate angle from top in radians
    radians <- Trees$Angle.degrees * pi /180
    # calculate height of tree using distance and angle calculated above
    height <- Trees$Distance.m * tan(radians)
    # save height in a vector
    Height.m <- c(height)
}
# create a data frame from data Trees and calculated heights
TreeHeight <- data.frame(Trees, Height.m)
# write dataframe to csv file and output in Results directory
write.csv(TreeHeight,"../Results/TreeHts.csv")

