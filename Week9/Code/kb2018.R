#!/usr/bin/env Rscript

rm(list=ls())
graphics.off()

###### Neutral Theory Simulations

# community <- vector where each number specifies species

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
# number of individuals <- size
# gives minimum value number of different species

initialise_min <- function(size){
    vmin <- rep(1, times<-size)
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
        xlab <- "Time (generations)", ylab <- "Species Richness (no. of species)",
        # do not plot any points (as line graph desired)
        type<-"n")
    # option to run a for loop for 100 iterations to plot multiple scenarios    
    # for(i in 1:100){
        # plot line of species richness against generations
        # without loop just plots a single line
        lines(neutral_time_series(initialise_max(100),200),type<-"l")
    # }
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
        xlab <- "Time (generations)", ylab <- "Species Richness (no. of species)",
        #set axis limits
        xlim <- c(0,200), ylim <- c(0,100),
        # do not plot any points (as line graph desired)
        type<-"n")
    lines(neutral_time_series_speciation(initialise_max(100),0.1,200),
            type<-"l", col<-"red")
    lines(neutral_time_series_speciation(initialise_min(100),0.1,200),
            type<-"l", col<-"blue")
    # run a for loop for 100 iterations to plot multiple scenarios    
    #  for(i in 1:100){
    # # plot line of species richness against generations
    #     lines(neutral_time_series_speciation(initialise_max(100),0.1,200),
    #         type<-"l", col<-"red")
    #     lines(neutral_time_series_speciation(initialise_min(100),0.1,200),
    #         type<-"l", col<-"blue")
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
    abundance <- sort(abundance, decreasing<-TRUE)
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

### 16) Neutral model simulation with 200 generation burn in period

question_16 <- function(){
    # intialise a maximum species abundance community
    community <- initialise_max(100)
    # burn in period of 200 generations
    for(d in 1:200){
        # overwrite community after each generation, with speciation of 0.1
        community <- neutral_generation_speciation(community,0.1)
    }
    # find out how many of each species abundance occur within the community
    octbin <- octaves(species_abundance(community))
    # for a further 2000 generations
    for(d in 1:2000){
        # find state of community after another 2000 generations 
        community <- neutral_generation_speciation(community,0.1)
        # every twenty years, append octbin vector with current values of octave
        if(d %% 20 == 0){
            octbin <- sum_vect(octbin, octaves(species_abundance(community)))
        }    
    }
    # find an average of the octaves 
    av_octbin <- octbin/101
    # x label of bar plot
    names <- seq(from<-0,to<-(length(av_octbin)-1))
    pdf("../Results/octave_plot.pdf")
    # bar plot of average octave bins 
    barplot(av_octbin, names.arg <- 2^(names), ylim<-c(0,12), 
            col<-rainbow(length(av_octbin)), xlab<-"Octave Bin", ylab <- "Average Species Abundance")
    dev.off()
}

# test function and plot:
# question_16()



##### Simulations using HPC

### 17) Function to run on cluster, see kb2018_cluster.R in zip file for running information

cluster_run <- function(speciation_rate,size,wall_time,interval_rich,interval_oct,burn_in_generations,output_file_name){
    # starts timer for function
    time1 <- proc.time()[3]
    # initialises community of input size, with minimum diversity
    community <- initialise_min(size)
    # record initial time
    time0 <- proc.time()[3]
    # sets initial generation value as 1
    count <-1
    # convert the time to seconds
    wall_time_s <- 60*wall_time
    # calculates initial species richness which should be 1
    species <- species_richness(community)
    # set an empty list for octave values
    octbin <- list(octaves(species_abundance(community)))
    # sets first element of list to the octave bins of initial community abundances
    # while simulation time is less than the time limit (converted into seconds)
    while((proc.time()[3]-time0) < wall_time_s){
        # loop through generations with specified population and speciation rates
        community<-neutral_generation_speciation(community,speciation_rate)
        # moves to next interation
        count <- count + 1 
        # while the generation is within the specified burn in generations and in the specified interval
        if((count<=burn_in_generations)&(count%%interval_rich == 0)){
            # calculate species richness and add to vector
            species <- append(species,species_richness(community))
        }
        # if generation is within interval
        if(count %% interval_oct == 0){
            # calculate octave bins and add to next position in list
            octbin <- c(octbin, list(octaves(species_abundance(community))))
        }
    }
    end_community <- community
    totaltime <- proc.time()[3] - time1
    # save outputs of the simulation into an rdata file with name specified in the command line
    parameters <- data.frame(speciation_rate,size,wall_time,interval_rich,interval_oct,burn_in_generations)
    save(parameters,species,octbin,end_community,totaltime, file=sprintf("%s.rda",paste(output_file_name,iter,sep="_")))
}


### 18 & 19) - See kb2018_cluster.R and kb2018_cluster_run.sh in kb2018_cluster.tar.gz 

### 20) Processing output from the cluster.

# load all Rdata files in directory

question_20 <- function(){
    cluster_results = list.files(path = "../Results", pattern = "*.rda")

# create blank vectors for each community size used
size_500 = c()
size_1000 = c()
size_2500 = c()
size_5000 = c()

# for every file
for(i in cluster_results){
    files = paste0("../Results", i)
    load(files)
    # add values to vector for each size
    switch(as.character(size),
        "500" = {size_500 <- append(size_500, files)},
        "1000" = {size_1000 <- append(size_1000, files)},
        "2500" = {size_2500 <- append(size_2500, files)},
        "5000" = {size_5000 <- append(size_5000, files)})
}

# make a panelled figure of 2x2
par(mfrow=c(2,2))

for (x in list(size_500, size_1000, size_2500, size_5000)){
    # intiate blank vector to hold average octave sizes
    octbin_sim = c()
    for (i in x) {
        # load the file into mem and set an empty vector for the octave totals
        load(i)
        # initiate vector for sum of octaves
        sum_octbin = c()
        # look at the proportion of octaves that correspond to burn in period
        end_burnin = burn_in_generations / interval_oct
        # keep a running total of octaves
        for (data in oct_abundance[end_burnin:length(oct_abundance)]) {
            sum_octbin = sum_vect(sum_octbin, data)
        }
        # calculate mean average of octaves
        av_octbin = unlist(lapply(sum_octbin, function(N) N/(length(oct_abundance) - end_burnin)))
        # add to average totals
        octbin_sim = sum_vect(octbin_sim, av_octbin)
    }
    # calculate overall averages for summed octaves
    av_octbin_sim = unlist(lapply(octbin_sim, function(N) N/length(x)))
    # plot barplot for simulation octaves
    barplot(av_octbin_sim, xlab = "Octaves",ylab = "Mean Average Species Abundance")
}
}

##### Fractals in Nature

### 21) Calculating the dimensions of two fractals - the Sierpinski 
# Carpet and the Menger Sponge

question_21 <- function(){
    # calculating dimensions of the Sierpinski Carpet
    sierpinski_carpet <- log(8) / log(3)
    print("The dimension of the Sierpinski Carpet is")
    print(sierpinski_carpet)
    # calculating the dimensions the Menger sponge
    menger_sponge <- log(20) / log(3)
    print("The dimension of the Menger Sponge is")
    print(menger_sponge)
}

# test function:
# question_21()

### 22) Simulating the chaos game, plotting a tranformed format of Sierpinski's Gasket.

chaos_game <- function(){
  # set the three options for points
  A <- c(0, 0)
  B <- c(3, 4)
  C <- c(4, 1)
  # create a list of the three points to choose from
  point_list <- list(A, B, C)
  # set starting point
  start <- c(0, 0)
  for (i in 1:1000) {
    # randomly select one of the points to draw towards
    random_point <- sample(3, 1)
    target <- unlist(point_list[random_point])
    # generate next point to draw towards
    x <- max(start[1], target[1]) - ((max(start[1], target[1]) - min(start[1], target[1]))/2)
    y <- max(start[2], target[2]) - ((max(start[2],  target[2]) - min(start[2], target[2]))/2)
    # plot the new point
    points(x, y, cex = 0.05)
    # overwrites initial starting points with new for next iteration
    start <- c(x, y)
  }
}

# to test function
# initiate blank plot before running function
# plot(1, type = "n", xlab="", ylab="", xlim = c(0,5), ylim=c(0,5), xaxt="n",yaxt="n",bty="n")
# chaos_game()

### 23) Draw a single line between a starting position, in a set angleection and of set length.

turtle <- function(start_pos, angle, length){
    # first line in comments initiates plots if being called individually, not needed due to preceding questions
    # calculates x and y co-ordinates of other end of line using start position and specified parameters
    point_y <- (sin(angle) * length) + start_pos[2]
    point_x <- (cos(angle) * length ) + start_pos[1]
    # draws line between the two points of specified colour
    segments(start_pos[1], start_pos[2], point_x, point_y,col<-"blue")
    # returns the coordinates of the lines end point
    return(c(point_x, point_y))
}

# testing the function:
# initiate blank plot
# plot(1, type <- "n", xlab<-"", ylab<-"",xlim <- c(0,10), ylim<-c(0,10), xaxt<-"n",yaxt<-"n",bty<-"n")
# turtle(c(2,2),1,1)

### 24) Uses turtle function to draw a pair of adjoining lines

elbow <- function(start_pos, angle, length){
    # store the first end point generated by turtle under end_point
    end_point <- turtle(start_pos, angle, length)
    # specify length of new line 
    new_length <- length*0.95
    # specify angleection of new line
    new_angle <- angle - pi/4
    # use turtle function a second time to draw the adjoining line with the calculated parameters
    turtle(end_point, new_angle, new_length)
}

# intiate blank plot then test function:
# plot(1, type <- "n", xlab<-"", ylab<-"",xlim <- c(0,10), ylim<-c(0,10), xaxt<-"n",yaxt<-"n",bty<-"n")
# elbow(c(3,4),pi,5)

### 25) Drawing an infinite spiral (will crash)

spiral <- function(start_pos, angle, length){
    # uses turtle to store the first turtle line end point for the start of the next turtle call
    end_point <- turtle(start_pos, angle, length)
    # specify length of new line 
    new_length <- length*0.95
    # specify angleection of new line
    new_angle <- angle - pi/4
    # calls itself to continue plotting
    spiral(end_point, new_angle, new_length)
}

# test function:
# plot(1, type <- "n", xlab<-"", ylab<-"",xlim <- c(0,10), ylim<-c(0,10), xaxt<-"n",yaxt<-"n",bty<-"n")
# spiral(c(1,1),2,3)
# will crash as inifinite loop

### 26) A non-infinite spiral.
spiral_2 <- function(start_pos, angle, length){
    end_point <- turtle(start_pos, angle, length)
    # specify length of new line
    new_length <- length*0.95
    # specify new angleection
    new_angle <- angle - pi/4
    # set a minimum length so spiral is only plotted if above set length
    # also provides end point to prevent infinite loop 
    if(length > 0.01){
        spiral_2(end_point, new_angle, new_length)
  }
}

# to test the spiral function and save image:
# pdf("../Results/spiral_2.pdf")
# plot(1, type <- "n", xlab<-"", ylab<-"",xlim <- c(0,10), ylim<-c(0,10), xaxt<-"n",yaxt<-"n",bty<-"n")
# spiral_2(c(1,1),2,3)
# dev.off()


### 27) Draw a tree using an adaptation of the spiral function in multiple angleections.


tree <- function(start_pos, angle, length){
    end_point <- turtle(start_pos, angle, length)
    # specify length of new line
    new_length <- length*0.65
    # specify new angleections, allow 1/4 pi radians in either angleection
    new_angle_r <- angle - pi/4
    new_angle_l <- angle + pi/4
    # set a minimum length so spiral is only plotted if above set length
    # also provides end point to prevent infinite loop 
    if(length > 0.05){
        # draw adjoining lines in both angleections
        tree(end_point, new_angle_r, new_length)
        tree(end_point, new_angle_l, new_length)
  }
}

# to test the spiral function and save image:
# pdf("../Results/tree.pdf")
# plot(1, type <- "n", xlab<-"", ylab<-"",xlim <- c(0,10), ylim<-c(0,10), xaxt<-"n",yaxt<-"n",bty<-"n")
# tree(c(5,1),pi/2,3)
# dev.off()


### 28) Use of the tree function to draw a half fern shape.

fern <- function(start_pos,angle,length,min_length=0.02){
    # first run to get new end point
    end_point <- turtle(start_pos,angle,length)
    # set min length as parameter so can be adjusted 
    if(length>min_length){
    # for lines to the left
    fern(end_point,angle-pi/4,length*0.38,min_length) 
    # straight lines
    fern(end_point,angle,length*0.87,min_length)
  }
}

# to test the spiral function and save image:
# pdf("../Results/fern.pdf")
# plot(1, type = "n", xlab="", ylab="", xlim = c(0,20), ylim=c(0,20), xaxt="n",yaxt="n",bty="n")
# fern(c(10,0),pi/2,2.5)
# dev.off()


### 29) Draw a full sized fern

fern_2 <- function(start_pos,angle,length,min_length=0.02, dir=1){
    # first run to get new end point
    end_point <- turtle(start_pos,angle,length)
    # make direction alternate between 1 and -1
    dir <- dir*-1
    # set min length as parameter so can be adjusted 
    if(length>min_length){
    # for lines to the left
    # adding a factor with alternating sign alternates side which line is drawn
    fern_2(end_point,angle-(dir*pi/4),length*0.38,min_length,dir) 
    # straight lines
    fern_2(end_point,angle,length*0.87,min_length,dir)
  }
}

# to test the spiral function and save image:
# pdf("../Results/fern_2.pdf")
# plot(1, type = "n", xlab="", ylab="", xlim = c(0,20), ylim=c(0,20), xaxt="n",yaxt="n",bty="n")
# fern_2(c(10,0),pi/2,2.5)
# dev.off()


#### Challenge Questions

### E) Chaos game continued:

# drawing Sierpinski's Gasket
challenge_E_initial <- function(){
  # set the three options for points
  A <- c(0, 0)
  B <- c(2, 0)
  C <- c(1, sqrt(3))
  # create a list of the three points to choose from
  point_list <- list(A, B, C)
  # set starting point
  start <- c(0, 0)
  for (i in 1:10000) {
    # randomly select one of the points to draw towards
    random_point <- sample(3, 1)
    target <- unlist(point_list[random_point])
    # generate next point to draw towards
    x <- max(start[1], target[1]) - ((max(start[1], target[1]) - min(start[1], target[1]))/2)
    y <- max(start[2], target[2]) - ((max(start[2],  target[2]) - min(start[2], target[2]))/2)
    # plot the new point
    points(x, y, cex = 0.05)
    # overwrites initial starting points with new for next iteration
    start <- c(x, y)
  }
}

# # test function:
# pdf("../Results/s_gasket.pdf")
# plot(1, type = "n", xlab="", ylab="",xlim = c(0,2), ylim=c(0,2), xaxt="n",yaxt="n",bty="n")
# challenge_E_initial()
# dev.off()