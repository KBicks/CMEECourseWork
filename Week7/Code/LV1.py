#!/usr/bin/env python3
"""Continuous time Lotka-Volterra model showing population densities for 
resources and consumers, over a set time period. Outputs figures showing 
the variation in population densities over time and a phase portrait for 
the system."""
__appname__ = "LV1.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "19-Nov-2018"

import scipy as sc
import scipy.integrate as integrate
# set default values, which starting t value, and define function
def dCR_dt(pops, t=0):

    #column for each R and C
    R = pops[0]
    C = pops[1]
    # equations for two parts of Lotka-Volterra in resource consumer model
    dRdt = r * R - a * R * C
    dCdt = -z * C + e * a * R * C

    # generates vector that stores population values for each timestep
    return sc.array([dRdt,dCdt])

# output is a function
type(dCR_dt)

# arbritary values for parameters
r  = 1.
a = 0.1
z = 1.5
e = 0.75

# time scales - 1000 time steps between 0 and 15
t = sc.linspace(0,15,1000)

# starting values for the populations
R0 = 10
C0 = 5
RC0 = sc.array([R0,C0])

# runs population model with function defined, starting value array input, time
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)
# type(infodict) #is a dictionary

# states whether integration was successful
infodict['message']

## Plotting the model

import matplotlib.pylab as p

# assign blank figure to variable
f1 = p.figure()

# plot resource population density
p.plot(t, pops[:,0], 'g-', label = 'Resource density')
# plot cosumer population density
p.plot(t, pops[:,1], 'b-', label = 'Consumer density')
# add grid to plot
p.grid()
# add legend is "best" location
p.legend(loc='best')
# label axes
p.xlabel('Time')
p.ylabel('Population Density')
# add title to graph
p.title('Consumer-Resource population dynamics')
#show figure
# p.show()

# save figure to pdf in Results
f1.savefig('../Results/LV_model.pdf')

# Phase portrait plot
# start second plot
f2 = p.figure()

# plot resource density against consumer density using a red line
p.plot(pops[:,0],pops[:,1], 'r-')
# insert a grid
p.grid()
# label axes
p.xlabel('Resource density')
p.ylabel('Consumer density')
# give figure a title
p.title('Consumer-Resource population dynamics')
# set axes limits
p.xlim(5,45)
p.ylim(2.5,25)

# save phase portrait as pdf in results
f2.savefig('../Results/LV_phaseportrait.pdf')