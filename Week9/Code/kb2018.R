#!/usr/bin/env Rscript

rm(list=ls())
graphics.off()

# community = vector where each number specifies species

### 1) Function for species richness - calculating number of different species

# species richness as a function of the vector community
species_richness <- function(community){
    # unique deletes repeats, so returns number of different values
    species<-length(unique(community))

    return(species)
} 

# run function by inserting values into the vector, where each value represents
# a different species:
# species_richness(c(1,2,3,4,5))


### 2) Function generating maximum number of species in a vector of 
# specified size

# function to generate vector of size (size)
initialise_max <- function(size){
    # generates a sequence of integers from 1 to size
    vmax <- seq_len(size)
    return(vmax)
}

# test function where size of community is 7:
# initialise_max(7)


### 3) Function generating vector of the same number
# number of individuals = size
# gives minimum value number of different species

initialise_min <- function(size){
    vmin <- rep(1, times=size)
    return(vmin)
}

# test function:
# initialise_min(6)

# test functions so far
# returns species richness as same as input:
# species_richness(initialise_max(6))
# returns species richness of one no matter value input:
# species_richness(initialise_min(6))

### 4) Generate a vector of length 2, with two random numbers between 1 and x

choose_two <- function(x){
    # set interval between 1 and x
    y <- 1:x
    # create a vector length two with 2 random integers within range
    z <- sample(y,2)
    return(z)
}

# test function:
# choose_two(4)


### 5) Neutral model simulation where a random individual dies and is replaced
# with the off-spring of another individual in the community

neutral_step <- function(community){
    # generate a random vector of 2, link to indexes of community vector
    p <- choose_two(length(community))
    # first number of vector indexes individual that dies
    # second number of vector indexes individual that reproduces and replaces
    community[p[1]]<-community[p[2]]
    return(community)
}

# test function:
# neutral_step(c(10,5,13))


### 6) State of community after one generation, with half the community being
# replaced

neutral_generation <- function(community){
    # set variable to length of community
    z <- length(community)
    # run half as many times as size of community (rounding up for odd values)
    for(x in 1:ceiling(z/2)){
        # use previous function, neutral_step
        # overwrite previous community each time
        community <- neutral_step(community)
    }
    # returns final state of community
    return(community)
}

# test function:
# neutral_generation(c(1:10))

### 7) Produce a time series of species richness over a set number of generations.

neutral_time_series <- function(initial,duration){
        # set the starting species richness of the initial population
        time_series<-c(species_richness(initial))
        # duration is the number of generations
        for(x in 1:duration){
            # overwrite the initial population with community after a generation
            initial<-neutral_generation(initial)
            # calculate species richness and set to sr
            sr<-species_richness(initial)
            # add sr to the current vector of the time series
            time_series<-c(time_series,sr)
        }
        return(time_series)
}

# testing neutral time series:
# neutral_time_series(initialise_max(7),20)

### 8) Plot the time series produced in question 7, with initial species richness
# set to a maximum, with a community of 100 individuals, over 200 generations. No
# inputs required to run functions. See kbicks.pdf for plot.

question_8 <- function(){
    # save plot as pdf
    pdf("../Results/time_series.pdf")
    # plot graph of the neutral_time_series function
    x<-plot(neutral_time_series(initialise_max(100),200),
        # add axes labels 
        xlab = "Time (generations)", ylab = "Species Richness (no. of species)",
        # do not plot any points (as line graph desired)
        type="n")
    # run a for loop for 100 iterations to plot multiple scenarios    
    for(i in 1:100){
        # plot line of species richness against generations
        lines(neutral_time_series(initialise_max(100),200),type="l")
    }
    # stop recording
    dev.off()
}

# function runs without inputs, to test:
# question_8()

### 9) Function where at every time step, either the individual that dies is 
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

# test function:
# neutral_step_speciation(c(10,5,13),0.2)

### 10) Returns the state of the community after a generation in which half
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

#test:
# neutral_generation_speciation(c(10,5,13),0.2)

### 11) Returns a time series of the changes to species richness, over a set
# number of generations, with a specified speciation probability.

neutral_time_series_speciation <- function(community,v,duration){
        # set the starting species richness of the initial population
        time_series_speciation<-c(species_richness(community))
        # duration is the number of generations
        for(x in 1:duration){
            # overwrite the initial population with community after a generation
            community<-neutral_generation_speciation(community,v)
            # calculate species richness and set to sr
            sr<-species_richness(community)
            # add sr to the current vector of the time series
            time_series_speciation<-c(time_series_speciation,sr)
        }
        return(time_series_speciation)
}

# test:
# neutral_time_series_speciation(initialise_min(100),0.1,10000)

### 12)

question_12 <- function(){
    # save plot as pdf
    pdf("../Results/time_series_speciation.pdf")
    # plot graph of the neutral_time_series function
    x<-plot(neutral_time_series_speciation(initialise_max(100),0.1,200),
        # add axes labels 
        xlab = "Time (generations)", ylab = "Species Richness (no. of species)",
        #set axis limits
        xlim = c(0,200), ylim = c(0,100),
        # do not plot any points (as line graph desired)
        type="n")
    lines(neutral_time_series_speciation(initialise_max(100),0.1,200),
            type="l", col="red")
    lines(neutral_time_series_speciation(initialise_min(100),0.1,200),
            type="l", col="blue")
    # run a for loop for 100 iterations to plot multiple scenarios    
    #  for(i in 1:100){
    # # plot line of species richness against generations
    #     lines(neutral_time_series_speciation(initialise_max(100),0.1,200),
    #         type="l", col="red")
    #     lines(neutral_time_series_speciation(initialise_min(100),0.1,200),
    #         type="l", col="blue")
    #  }
    # stop recording
    dev.off()
}

# function runs without inputs, to test:
# question_12()


### 13) Gives species abundances in descending order, as a vector.

species_abundance <- function(community){
    # sorts vector into table of abundances, with species as headers
    abundance <- table(community)
    # converts abundance to a numeric vector of abundances
    abundance <- as.numeric(abundance)
    # sorts abundances in descending order
    abundance <- sort(abundance, decreasing=TRUE)
    return(abundance)
}

# should output 3,2,2,1 using the test below:
# species_abundance(c(1,5,3,6,5,6,1,1))

### 14) Gives list of how many species of each abundance occur, starting with 
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

# to test:
# octaves((c(100,64,63,5,4,3,2,2,1,1,1,1)))

### 15) Sum two vectors, element-wise, if the vectors are different lengths, add
# append the shorter vector with zeros to make vectors the same length, then add.

sum_vect <- function(x,y){
    # in the case where vector x is longer than vector y
    if(length(x)>length(y)){
        # make a vector of zeros the length of the difference between the vectors
        z <- rep(0, (length(x)-length(y)))
        # append the shorter vector with the vector of zeros
        y <- c(y,z)
    } else{
        # where the above is not true, perform the same process on
        # the shorter vector
        z <- rep(0, (length(y)-length(x)))
        x <- c(x,z) 
    }
    # sum the two vectors
    v <- x + y
    return(v)
}

# test, with output should be (2,3,4,2):
# sum_vect(c(1,3),c(1,0,5,2))

### 16) 

question_16 <- function(){
    community <- initialise_max(100)
    for(d in 1:200){
        community <- neutral_generation_speciation(community,0.1)
    }
    octbin <- octaves(species_abundance(community))
    for(d in 1:2000){
        community <- neutral_generation_speciation(community,0.1)
        if(d %% 20 == 0){
            octbin <- sum_vect(octbin, octaves(species_abundance(community)))
        }    
    }
    av_octbin <- octbin/101
    names <- seq(from=0,to=(length(av_octbin)-1))
    barplot(av_octbin, names.arg = 2^(names), ylim=c(0,12), 
            col=rainbow(length(av_octbin)), xlab="Octave Bin", ylab = "Average Species Abundance")
}

# test function and plot:
# question_16()

### 17) - See kb2018_cluster.R in zip file