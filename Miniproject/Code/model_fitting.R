#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: data_wrangling.R
# Desc: Manipulated data into format required for model fitting miniproject.
# Arguments: none
# Date: 28 Feb 2019

rm(list=ls())
graphics.off()

# load required packages
require(ggplot2)
require(repr)
options(repr.plot.width=6, repr.plot.height=5)
require(minpack.lm)
# require(R2jags)
# require(coda)

# options to change default plot size where needed


# reading in dataframe
iucn <- read.csv("../Data/iucn_data.csv", header=TRUE, na.strings=c("","NA"))
# names(iucn)
# plot(iucn$prop_threatened~iucn$average_57year)
# plot(iucn$average_57year~iucn$ex_risk)
# model <- lm(iucn$average_57year~iucn$prop_threatened)
# plot(model)
# model2<-lm(iucn$average_57year~iucn$ex_risk)
# plot(model2)
# hist(iucn$ex_risk)

powMod <- function(,a,b){
    y <- a*((x)^b)
    return((x)^b)
}

require(dplyr)
glimpse(iucn)

plot(iucn$average_57year_t,log(iucn$ex_risk))
x <- lm(log(iucn$ex_risk)~iucn$average_57year_t)
summary(x)

# as power laws do not work for negatives in r, add the modulus of the min 
# value of x to transform above 0
t <- abs(min(iucn$average_57year))
iucn$average_57year_t <- iucn$average_57year + t
mod <- powMod(iucn$average_57year_t,.1,.1)
# remove NAs
iucn <- iucn[!is.na(iucn$average_57year_t),]
iucn <- iucn[!is.na(iucn$ex_risk),]

plot(iucn$average_57year_t,iucn$ex_risk)
ggplot(iucn, aes(x = average_57year_t, y = ex_risk)) + geom_point()

powFit <- nlsLM(ex_risk~powMod(average_57year_t,a,b), data = iucn, start = list(a=0.2,b=-0.3))


sts.ex.sat <- subset(iucn, select = c("average_57year","ex_risk"))
summary(sts.ex.sat)
cor(sts.ex.sat)