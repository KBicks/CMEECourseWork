#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: Girko.R
# Desc: Plots a simulation of Girko's law and saves to pdf in Results directory.
# Arguments: none
# Date: 22 Oct 2018

rm(list=ls())

# function that returns an ellipse
build_ellipse <- function(hradius, vradius){ 
  npoints = 250
  a <- seq(0, 2 * pi, length = npoints + 1)
  x <- hradius * cos(a)
  y <- vradius * sin(a)  
  return(data.frame(x = x, y = y))
}

N <- 250 # Assign size of the matrix
M <- matrix(rnorm(N * N), N, N) # Build the matrix
eigvals <- eigen(M)$values # Find the eigenvalues
eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals)) # Build a dataframe
my_radius <- sqrt(N) # The radius of the circle is sqrt(N)
ellDF <- build_ellipse(my_radius, my_radius) # Dataframe to plot the ellipse
names(ellDF) <- c("Real", "Imaginary") # rename the columns


# plot the eigenvalues
require(ggplot2)
# uses ggplot to plot eigenvalues on real and imaginary axes
p <- ggplot(eigDF, aes(x = Real, y = Imaginary))
p <- p +
  # specifies shape of points
  geom_point(shape = I(3)) +
  # removes legend
  theme(legend.position = "none")

# now add the vertical and horizontal line
p <- p + geom_hline(aes(yintercept = 0))
p <- p + geom_vline(aes(xintercept = 0))

# finally, add the ellipse
p <- p + geom_polygon(data = ellDF, aes(x = Real, y = Imaginary, alpha = 1/20, fill = "red"))
# prints image to pdf
pdf("../Results/Girko.pdf")
print(p)
dev.off()
