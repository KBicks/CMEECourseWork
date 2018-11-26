#!/usr/bin/env Rscript

rm(list=ls())
graphics.off()

# community = vector where each number specifies species

# 1) Function for species richness


species_richness <- function(community){
    species<-length(unique(community))

    return(species)
} 

species_richness(c())