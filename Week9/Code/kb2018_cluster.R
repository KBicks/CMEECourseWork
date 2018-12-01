#!/usr/bin/env Rscript

### R script to run on the HPC cluster

rm(list=ls())
graphics.off()

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
if(is.na(iter)){
    iter <- sample(1:100,1)
}
set.seed(iter)
size_vector <- c(500,1000,2500,5000)
size <- size_vector[(iter %% 4)+1]

# Neutral model simulation where a random individual dies and is replaced
# with the off-spring of another individual in the community

neutral_step <- function(community){
    # generate a random vector of 2, link to indexes of community vector
    p <- choose_two(length(community))
    # first number of vector indexes individual that dies
    # second number of vector indexes individual that reproduces and replaces
    community[p[1]]<-community[p[2]]
    return(community)
}


# Generate a vector of length 2, with two random numbers between 1 and x
choose_two <- function(x){
    # set interval between 1 and x
    y <- 1:x
    # create a vector length two with 2 random integers within range
    z <- sample(y,2)
    return(z)
}

# Function where at every time step, either the individual that dies is 
# either replaced with the offspring of another member of the community or is
# replaced by a new species. Speciation occurs with probability of v.
neutral_step_speciation <- function(community,v){
    # generate a random number between 0 and 1
    r <- runif(1)
    # if the random number is less that the probability of speciation
    if(r < v){
    # select a random member of community
    y <- 1:length(community)
    z <- sample(y,1)
    # replace dead individual with a new species 
    community[z] <- max(community)+1
    } else{
        # replace the individual that dies with offspring of another member
        community <- neutral_step(community)
    }
    return(community)
}    

# Returns the state of the community after a generation in which half
# the individuals in the community are replaced by either offspring of other
# individuals or a new species, with speciation probability v.
neutral_generation_speciation <- function(community,v){
    # set variable to length of community
    z <- length(community)
    # run half as many times as size of community (rounding up for odd values)
    for(x in 1:ceiling(z/2)){
        # use previous function, neutral_step
        # overwrite previous community each time
        community <- neutral_step_speciation(community,v)
    }
    # returns final state of community
    return(community)
}

# Function for species richness - calculating number of different species
# species richness as a function of the vector community
species_richness <- function(community){
    # unique deletes repeats, so returns number of different values
    species<-length(unique(community))

    return(species)
} 

# Gives species abundances in descending order, as a vector.
species_abundance <- function(community){
    # sorts vector into table of abundances, with species as headers
    abundance <- table(community)
    # converts abundance to a numeric vector of abundances
    abundance <- as.numeric(abundance)
    # sorts abundances in descending order
    abundance <- sort(abundance, decreasing=TRUE)
    return(abundance)
}

# Gives list of how many species of each abundance occur, starting with 
# rarest species.
octaves <- function(abundance){
    # calculate logs of abundances to base 2
    octbin <- log2(abundance)
    # rounds log values down to nearest integer
    octbin <- floor(octbin)
    # sort into order, with rarerest species first - i.e. smallest abundance first
    octbin <- tabulate(octbin+1)
    return(octbin)
}

# Generates a vector of 1s of length specified
initialise_min <- function(size){
    vmin <- rep(1, times=size)
    return(vmin)
}

### 17) Runs a simulation of speciation in a community over a set time.

cluster_run <- function(speciation_rate,size,wall_time,interval_rich,interval_oct,burn_in_generations,output_file_name){
    # starts timer for function
    time <- proc.time()[3]
    # sets initial generation value as 1
    i <-1
    # initialises community of input size, with minimum diversity
    community <- initialise_min(size)
    # calculates initial species richness which should be 1
    species <- species_richness(community)
    # set an empty list for octave values
    octbin <- list()
    # sets first element of list to the octave bins of initial community abundances
    octbin[[1]] <- octaves(species_abundance(community))
    # while simulation time is less than the time limit (converted into seconds)
    while(wall_time*60 > (proc.time()[3]-time)){
        # loop through generations with specified population and speciation rates
        community<-neutral_generation_speciation(community,speciation_rate)
        # while the generation is within the specified burn in generations and in the specified interval
        if((i<=burn_in_generations) && (i %% interval_rich == 0)){
            # calculate species richness and add to vector
            species <- c(species, species_richness(community))
        }
        # if generation is within interval
        if(i %% interval_oct == 0){
            # calculate octave bins and add to next position in list
            octbin[[length(octbin)+1]] <- octaves(species_abundance(community))
        }
    # initiate next generation
    i <- i+1
    }
    # record the final time - subtracting current from starting time
    endtime <- proc.time()[3] - time
    # save outputs of the simulation into an rdata file with name specified in the command line
    save(species,octbin,community,endtime,speciation_rate,size,wall_time,interval_rich,interval_oct,burn_in_generations, file=sprintf("../Results/%s.rda",paste(output_file_name,iter, sep = "_")))
}

# testing:
# cluster_run(0.04,100,0.1,2,20,10,"kb2018_cluster_results")

