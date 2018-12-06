#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: fmr.R
# Desc: Plots metabolic rate against body mass for the Nagy et al 1999 dataset.
# Arguments: none 
# Date: 16 Oct 2018

rm(list=ls())

# Plots log(field metabolic rate) against log(body mass) for the Nagy et al 
# 1999 dataset to a file fmr.pdf.

# print reading the csv
cat("Reading CSV\n")

# read in from csv and set data to variable 
nagy <- read.csv('../Data/NagyEtAl1999.csv', stringsAsFactors = FALSE)

cat("Creating graph\n")
# open blank pdf
pdf('../Results/fmr_plot.pdf', 11, 8.5)
# set colours for variables
col <- c(Aves='purple3', Mammalia='red3', Reptilia='green3')
# plot graph of metabolic rate against mass (logged), graphical parameters specified
plot(log10(nagy$M.g), log10(nagy$FMR.kJ.day.1), pch=19, col=col[nagy$Class], 
     xlab=~log[10](M), ylab=~log[10](FMR))
# model each class and plot abline of the model onto graph
for(class in unique(nagy$Class)){
    model <- lm(log10(FMR.kJ.day.1) ~ log10(M.g), data=nagy[nagy$Class==class,])
    abline(model, col=col[class])
}
# stop recording to pdf
dev.off()

cat("Finished in R!\n")