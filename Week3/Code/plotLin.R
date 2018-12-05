#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: plotLin.R
# Desc: Exemplifies using ggplot to annotate and manipulate plots.
# Arguments: none
# Date: 22 Oct 2018

rm(list=ls())#Mathematical display

require(ggplot2)

x <- seq(0, 100, by = 0.1)
y <- -4. + 0.25 * x +
  rnorm(length(x), mean = 0., sd = 2.5)

# and put them in a dataframe
my_data <- data.frame(x = x, y = y)

# perform a linear regression
my_lm <- summary(lm(y ~ x, data = my_data))

# plot the data
p <-  ggplot(my_data, aes(x = x, y = y,
                          colour = abs(my_lm$residual))
             ) +
  # add points to the data
  geom_point() +
  # sets colours of gradient
  scale_colour_gradient(low = "black", high = "red") +
  # removes legend
  theme(legend.position = "none") +
  # sets scale to contiuous labelled with expression
  scale_x_continuous(
    expression(alpha^2 * pi / beta * sqrt(Theta)))

# add the regression line
p <- p + geom_abline(
  # specify intercept
  intercept = my_lm$coefficients[1][1],
  # specify gradient
  slope = my_lm$coefficients[2][1],
  # specify colour
  colour = "red")
# annotate plot using equation
p <- p + geom_text(aes(x = 60, y = 0,
                       label = "sqrt(alpha) * 2* pi"), 
                       parse = TRUE, size = 6, 
                       colour = "blue")

# save plot as a pdf
pdf("../Results/MyLinReg.pdf")
print(p)
dev.off()