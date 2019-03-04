#!/usr/bin/env python3
"""Manipulated large dataset (see report for source) to extract variables
needed for model building and fitting in R."""
__appname__ = "data_wrangling.py"
__author__ = "Katie Bickerton <k.bickerton18@imperial.ac.uk>"
__version__ = "3.5.2"
__date__ = "21-Feb-2019"

# required modules for data import and manipulation
import numpy as np
import pandas as pd
import scipy as sp
import csv
import statistics
from statistics import mean

# read raw data
data = pd.read_csv("pred_prey.csv")
# remove spaces in column headers
data.columns = [x.replace(" ","_") for x in data.columns]

# subset required columns
pp = pd.DataFrame(data[[3,7,15,25,27,35,45,52,53,54,55,56,58]])
# remove spaces from dataframe
pp = pp.replace(" ","_",regex=True)

# intiate empty series to be compiled during loop
predator = pd.Series()
pred_meanmass = pd.Series()
pred_meanlength = pd.Series()
prey_meanmass = pd.Series()
prey_meanlength = pd.Series()
feeding_interaction = pd.Series()
habitat = pd.Series()
depth_mean = pd.Series()
temp_mean = pd.Series()
prec_mean = pd.Series()

# for each species of predator in dataset
for x in pp.Predator:
    # store name of predator
    predator[x] = x
    # calculate mean mass of each predator
    pred_meanmass[x] = mean(pp.SI_predator_mass[pp.Predator == x])
    # calculate mean length of each predator
    pred_meanlength[x] = mean(pp.Standardised_predator_length[pp.Predator == x])
    # calculate mean mass of all prey species for the predator
    prey_meanmass[x] = mean(pp.SI_prey_mass[pp.Predator == x])
    # calculate mean length of all prey species for the predator
    prey_meanlength[x] = mean(pp.SI_prey_length[pp.Predator == x])
    # finds most common feeding interaction seen per predator
    feeding_interaction[x] = pp.Type_of_feeding_interaction[pp.Predator == x].describe()[2]
    # habitat the predator was most often seen feeding within
    habitat[x] = pp.Specific_habitat[pp.Predator == x].describe()[2]
    # mean depth recorded
    depth_mean[x] = mean(pp.Depth[pp.Predator == x])
    # mean temperature recorded annually
    temp_mean[x] = mean(pp.Mean_annual_temp[pp.Predator == x])
    # mean precipitaion recorded annually
    prec_mean[x] = mean(pp.Mean_PP[pp.Predator == x])


# combines series generated above into a single dataframe by the predator name
averaged = pd.concat([predator,pred_meanmass,pred_meanlength,prey_meanmass,prey_meanlength,
feeding_interaction,habitat,depth_mean,temp_mean,prec_mean],axis=1, ignore_index=True)

# assign column names
averaged.columns = ['pred_species','pred_meanmass','pred_meanlength','prey_meanmass','prey_meanlength','feeding_interaction',
'habitat','depth_mean','temp_mean','prec_mean']

# save dataframe to csv for use in R
averaged.to_csv('../Data/predprey.csv',sep=',', index=False)