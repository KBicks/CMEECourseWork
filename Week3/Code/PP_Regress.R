#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: PP_Regress.R
# Desc: Calculating multiple regressions, saving results into a csv, and plotting
#       regressions.
# Arguments: none
# Date: 23 Oct 2018

rm(list=ls())

# packages required
require(ggplot2)
require(plyr)
require(dplyr)

# read data 
PredPrey <- read.csv("../Data/EcolArchives-E089-51-D1.csv", header=T)
# summary of data
dplyr::glimpse(PredPrey)
dplyr::tbl_df(PredPrey)

# plot figure
InterPlot <- qplot(
    # mass of preadtor against mass of prey
    Prey.mass, Predator.mass,
    # split by feeding interaction type
    facets = Type.of.feeding.interaction ~.,
    data = PredPrey,
    # using a log scale
    log = "xy",
    # set colours by predator lifestage
    colour = Predator.lifestage,
    # label axes
    xlab = "Prey Mass in grams",
    ylab = "Predator Mass in grams")
# add results of linear model to plot and position legend
Finalplot <- InterPlot + geom_smooth(method = "lm", fullrange = T) + geom_point(shape = 9) +
     theme_bw() + theme(legend.position="bottom")

# save plot to pdf
pdf("../Results/PP_Regress.pdf", 11.7, 8.3)
print(Finalplot)
graphics.off()

# regression model of interactions
model.grouped <- dlply(PredPrey, .(Type.of.feeding.interaction,Predator.lifestage), function(PredPrey) lm(log(Predator.mass)~log(Prey.mass), data=PredPrey))

# summary of the model - function generating specific values required
model.sum <- ldply(model.grouped, function(PredPrey){
    intercept <- summary(PredPrey)$coefficients[1]
    slope <- summary(PredPrey)$coefficients[2]
    p.value <- summary(PredPrey)$coefficients[8]
    R2 <- summary(PredPrey)$r.squared
    # sets values extracted as a dataframe
    data.frame(slope,intercept,R2,p.value)
})

# calculates the F statistic and data.frame
F.statistic <- ldply(model.grouped, function(PredPrey) summary(PredPrey)$fstatistic[1])
# merges the data.frame with F statistic
model.sum <- merge(model.sum, F.statistic, by = c("Type.of.feeding.interaction","Predator.lifestage"),all=T)

# set column names in data frame
names(model.sum)[3] <- "Regression.slope"
names(model.sum)[4] <- "Regression.intercept"
names(model.sum)[7] <- "F-Statistic"
names(model.sum)[6] <- "P-Value"

# write results to a csv, without quotations for strings
write.csv(model.sum,"../Results/PP_Regress_Results.csv", row.names=F, quote=F)