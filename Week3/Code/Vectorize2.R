#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: Vectorize.R
# Desc: Runs a stochastic version of the Ricker model, comparing methods using
#       for loops and vectorization.
# Arguments: p0 <- intial population
# Date: 20 Oct 2018

# Runs the stochastic (with gaussian fluctuations) Ricker Eqn .
#remove R history
rm(list=ls())

# Before vectorization
stochrick<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100)
{
  #initialize
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0
  
  #for every population
  for (pop in 1:length(p0)) {
  #for every year in each population
   for (yr in 2:numyears) 
    {
      #stochastic Ricker equation:
    N[yr,pop]<-N[yr-1,pop]*exp(r*(1-N[yr-1,pop]/K)+rnorm(1,0,sigma))
    }
  }
 return(N)
}

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

# Vectorized version
stochrickvect<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100)
{
  #initialize
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0
  
  #for (pop in 1:length(p0)) #loop through the populations
  
  for (yr in 2:numyears) #for each pop, loop through the years
    {
    N[yr,]<-N[yr-1,]*exp(r*(1-N[yr-1,]/K)+rnorm(1,0,sigma))
    }

 return(N)
}

# print the time taken for the original function
print("Stochastic Ricker takes:")
print(system.time(stochrick()))
# and the time taken for the vectorized function
print("Vectorized Stochastic Ricker takes:")
print(system.time(stochrickvect()))