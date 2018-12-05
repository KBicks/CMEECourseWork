#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: PP_Lattice.R
# Desc: Produces lattice plots for the predator prey data provided and outputs as
#       pdfs, and calculates and saves summary statistics to a csv file.
# Arguments: none 
# Date: 22 Oct 2018

rm(list=ls())

# required packages for analysis
require(lattice)
require(dplyr)
require(ggplot2)

# load the csv data file and assign to variable
PredPrey <- read.csv("../Data/EcolArchives-E089-51-D1.csv", header=T)
# view a portion of the data
dplyr::tbl_df(PredPrey)
dplyr::glimpse(PredPrey)

## for the three sections below:

# opens blank pdf in specified location, of specified size
pdf("../Results/Prey_Lattice.pdf", 11.7,8.3)
# plots lattice plot of variable, stratified by feeding interaction type
qplot(log(Prey.mass), facets = Type.of.feeding.interaction ~., 
    data = PredPrey, geom = "density", xlab="Prey Mass (kg)")
    # finished recording to pdf
dev.off()

pdf("../Results/Pred_Lattice.pdf", 11.7,8.3)
qplot(log(Predator.mass), facets = Type.of.feeding.interaction ~., 
    data = PredPrey, geom = "density", xlab="Predator Mass (kg)")
dev.off()

pdf("../Results/SizeRatio_Lattice.pdf",11.7,8.3)
qplot(log(Predator.mass/Prey.mass), facets = Type.of.feeding.interaction ~., 
    data = PredPrey, geom = "density", xlab="Ratio of Predator to Prey Mass")
dev.off()


## for three sections below:

# provides summary data of variable by feeding interaction
Prey <- PredPrey %>% group_by(Type.of.feeding.interaction) %>% summarise(
    Mean= mean(log(Prey.mass)), Median = median(log(Prey.mass))
)
# sets new column in data
Prey$"Type" <- "Log.Prey.Mass"

Pred <- PredPrey %>% group_by(Type.of.feeding.interaction) %>% summarise(
    Mean= mean(log(Predator.mass)), Median = median(log(Predator.mass))
)
Pred$"Type" <- "Log.Predator.Mass)"

PredPreyRatio <- PredPrey %>% group_by(Type.of.feeding.interaction) %>% summarise(
    Mean= mean(log(Predator.mass/Prey.mass)), Median = median(log(Predator.mass/Prey.mass))
)
PredPreyRatio$"Type" <- "Log.predator.prey.size.ratio"

# binds summary rows
SummaryStats <- rbind(Pred,Prey,PredPreyRatio)
# writes summary statistics to csv in Results directory
write.csv(SummaryStats, "../Results/PP_Results.csv", row.names=F )