#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: model_fitting.R
# Desc: Builds models for pred_prey dataset, fits models using appropriate 
# methods for each model, plots models and compares models using the Akaike 
# information criterion. 
# Arguments: none
# Date: 28 Feb 2019

# clear workspace
rm(list=ls())
graphics.off()

# load required packages
require(dplyr)
require(ggplot2)
require(repr)
require(minpack.lm)
require(nlme)
require(mgcv)

# reading in dataframe
p <- read.csv("../Data/pred_prey_wrangled.csv", header=TRUE, na.strings=c("","NA"))


#### General Data Exploration

# plotting response and possible explanatory variables

# Predator Mass - response variable (y)
# not normally distributed
hist(p$pred_meanmass)
# try log transform = more normal distribution
hist(log(p$pred_meanmass))

# Prey mass - possible explanatory variable
# not normally distributed 
hist(p$prey_meanmass)
# try of log transform = nearer normal distribution
hist(log(p$prey_meanmass))

# Prey Length - possible explanatory variable
# right skewed data
hist(p$prey_meanlength)
# log transformed = nearer normal distribution
hist(log(p$prey_meanlength))

# Depth - possible explanatory variable
# non normal distribution
hist(p$depth_mean)
# try log transform = nearer normal distribution
hist(log(p$depth_mean))

# Temperature - possible explanatory variable
# near normal distribution
hist(p$temp_mean)

# Habitat is also potential explanatory variable
# factor not numeric data
plot(p$habitat)

# Feeding interaction is a potential explanatory variable
# factor not numeric
plot(p$feeding_interaction)


####### MODEL 1 - Linear Regression Model with Log Transform

# Building a suitable linear regression model from the available variables

# first linear model, log transforms for non-normal data
m1 <- lm(log(pred_meanmass) ~ log(prey_meanmass) + log(prey_meanlength) + log(depth_mean) + temp_mean + habitat + feeding_interaction, data = p)

# as this is a linear model, model fitting can be carried out using summary and anova
# outputs from summary and anova indicate that there is a significant result but do not specify the explanatory variable responsible
m1sum <- summary(m1)
m1ano <- anova(m1)
# as there are so many potential explanatory variables, that AIC will be used to find the best linear regression model for the data
m1step <- step(m1)

# results from the step function indicate the best fit of AIC  for all explanatory variables is mean prey length therefore the model will take the form:
lin_model <- lm(log(pred_meanmass)~log(prey_meanlength), data = p)
lin_model_sum <- summary(lin_model)

# extract coefficients from model
a = coef(lin_model)[[1]]
b = coef(lin_model)[[2]]

# generate equally spaces sequence of prey lengths to fit in same range as measured lengths
prey_lengths <- seq(min(p$prey_meanlength), max(p$prey_meanlength), len = 57)

# fit prediction model to variables and sample lengths
predict_lin_model <- predict.lm(lin_model, data.frame(prey_meanlength = prey_lengths))



####### MODEL 2 - General Additive Model (GAM)





plot(log(p$pred_meanmass)~log(p$prey_meanlength))
lines(log(prey_lengths), predict_lin_model, col = 3, lwd = 2)

