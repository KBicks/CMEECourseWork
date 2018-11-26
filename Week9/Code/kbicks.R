#!/usr/bin/env Rscript

rm(list=ls())
graphics.off()

# community = vector where each number specifies species

# 1) Function for species richness

# species richness as a function of the vector community
species_richness <- function(community){
    # unique deletes repeats, so returns number of different values
    species<-length(unique(community))

    return(species)
} 

# run function by inserting values into the vector, where each value represents
# a different species
species_richness(c())