#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: maps.R
# Desc: Plots a world map with data points from the specified data set.
# Arguments: none
# Date: Oct 2018

rm(list=ls())

# require library
library(maps)

# load RData file
load("../Data/GPDDFiltered.RData")

# produce map of world
map("world")
# add data points in specified format by coordinates
points(gpdd$long,gpdd$lat,pch=19, col="blue")

## Answer to practical question:

# The distribution of the data is localised to several specific areas indicating
# biased location of data collection, and is unlikely to be suitable to be 
# examined on a global scale.