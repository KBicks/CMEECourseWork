#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: Movement_Networks.R 
# Desc: Building movement networks and visualisations from acoustic telemetry data,
#       and calculating network metrics for the attribute file.
# Arguments: None
# Date: 20 Mar 2019

rm(list=ls())
graphics.off()

# packages required for data manipulation and network building
require(igraph)
require(rgdal)
require(lubridate)
require(tidyverse)

## Data required to be sorted by individual then by time, with dates in 
#format: 'yyyy/mm/dd hh:mm:ss'
# strings as factors required as code uses strings in network
sharks <- read.csv("../Data/sharkdata.csv", header=TRUE, stringsAsFactors = FALSE)
ss <- read.csv("../Data/sunrise_sunset.csv", header = TRUE)
# change species name from Thickskin to Sandbar
sharks$Species<- gsub("Thickskin","Sandbar",sharks$Species) 
# order data by tag code, then date, then time
sharks <- sharks[order(sharks$TagCode.original, sharks$Date.local, 
sharks$Time.local),]




##### CALCULATING MOVEMENTS #####

# set variables for calculating movements
AID <- sharks$TagCode.original
LOC <- sharks$Name1

# calculate differences (running) in ID tags
sharks$diff_ID <- c(0, diff(AID))
# calculate running differences in location
sharks$diff_loc <- c(0, diff(as.factor(LOC)))
# calculate running differences in times as numerical values (in seconds)
sharks$time_sec <- as.numeric(strptime(sharks$DateTime.local, 
format = "%Y-%m-%d %H:%M"))
# calculate differences between times and convert into minutes
sharks$time_diff_mins <- c(0, diff(sharks$time_sec)/60)

# a vector of every time the same shark moved
move <- (sharks$diff_ID ==0 & sharks$diff_loc!=0)
# set empty vectors of correct dimensions to populate
b <- rep(NA, length(move))
a <- rep(NA, length(move))
c <- rep(NA, length(move))
d <- rep(NA, length(move))
e <- rep(NA, length(move))

# where data is present, so movement occurred, give location of start 
# and finish of each movement
b[move] <- sharks[move, 17] 
a[move] <- sharks[(which(move)-1), 17] 
c[move] <- c(1:length(which(move)))
d[move] <- sharks[move, 2]
e[move] <- sharks[(which(move)-1), 2]

# add movements to dataframe
sharks$From <- a
sharks$To <- b
sharks$Movement <- c

# write as csv for individual analysis
# sharks_for_file <- na.omit(sharks) # omit non-movements
write.csv(sharks,"../Data/shark_movements.csv", row.names = FALSE)







##### POPULATION LEVEL NETWORK FOR WHOLE RANGE #####

### Non-proportional simple edge count matrices

# creates an edge list using the 'from' and 'to' columns for latitude and longitude
el <- sharks[,c(22,23)] 
# omit NAs
el <- na.omit(el)
# give time taken for movement
el_time <- sharks[,c(22,23,21)]
el_time <- na.omit(el_time)

# creates a non-directed dataframe
G <- graph.data.frame(el,directed=FALSE) 
# and turns it into a adjacency matrix
net <- as_adjacency_matrix(G) 
net <- as.matrix(net)
GRS <- graph.adjacency(net, mode = "directed", diag = FALSE, weighted = TRUE) 


### Visualisations 

# Location attributes
# receiver attribute file needed with lon/lat coords
att <- read.csv("../Data/receivers.csv", header = TRUE)
coordinates(att) <- c("Longitude1","Latitude1")
# plot receiver locations
# plot(att, pch=20, cex=1, col="gold")

# set names as characters for matching
att$Name1 <- as.character(att$Name1)
# match nodes to receiver locations
poss <- match(V(GRS)$name, att$Name1)
V(GRS)$long <- att$Longitude1[poss]
V(GRS)$lat <- att$Latitude1[poss]
V(GRS)$name <- att$Name1[poss]

# determine the range for the edge weights
E(GRS)$width <- sqrt(E(GRS)$weight)
# network metrics
d_all <- ecount(GRS)/(vcount(GRS)* (vcount(GRS)-1))
r_mut_all <- dyad_census(GRS)$mut
r_null_all <- dyad_census(GRS)$null
metrics_all <- c("all",d_all,r_mut_all,r_null_all)

# set network layout as locations
lay <- matrix(c(V(GRS)$long, V(GRS)$lat), ncol=2)


# # read in and plot a shapefile of Australia
# aus <- readOGR("../Data/AU_shapefiles","gadm36_AUS_2")
# aus <- plot(aus, xlim = c(min(att$Longitude1), max(att$Longitude1)), 
#             ylim = c(min(att$Latitude1), max(att$Latitude1)+2))

# # plot the network onto map
# population_network_map <- plot(GRS, layout=lay, vertex.size=1, vertex.label = NA, 
#      vertex.frame.color='black', edge.curved=-0.1, edge.arrow.size = 0.1, add=TRUE, rescale=FALSE)










##### MALE VS FEMALE NETWORKS WHOLE RANGE #####

# set empty vectors for metrics
sex <- c()
density_allsex <- c()
recip_mut_allsex <- c()
recip_null_allsex <- c()

for(x in unique(sharks$Sex)){
     sharks_sex <- sharks[sharks$Sex == x,]
     # creates an edge list using the 'from' and 'to' columns for latitude 
     # and longitude
     el_sex <- sharks_sex[,c(22,23)] 
     # omit NAs
     el_sex <- na.omit(el_sex)
     # give time taken for movement
     el_time_sex <- sharks_sex[,c(22,23,21)]
     el_time_sex <- na.omit(el_time_sex)

     # creates a non-directed dataframe
     GRS_sex <- graph.data.frame(el_sex,directed=FALSE) 
     # and turns it into a adjacency matrix
     net_sex <- as_adjacency_matrix(GRS_sex) 
     net_sex <- as.matrix(net_sex)
     GRS_sex <- graph.adjacency(net_sex, mode = "directed", diag = FALSE, 
     weighted = TRUE) 
     # calculates weigthed degree for each node
     # graph.strength(GRS) 

     # match nodes to receiver locations
     poss_sex <- match(V(GRS_sex)$name, att$Name1)
     V(GRS_sex)$long <- att$Longitude1[poss_sex]
     V(GRS_sex)$lat <- att$Latitude1[poss_sex]
     V(GRS_sex)$name <- att$Name1[poss_sex]

     # determine the range for the edge weights
     E(GRS_sex)$width <- sqrt(E(GRS_sex)$weight)
     # network metrics
     sex <- append(sex,x)
     d_allsex <- ecount(GRS_sex)/(vcount(GRS_sex)* (vcount(GRS_sex)-1))
     density_allsex <- append(density_allsex, d_allsex)
     r_mut_allsex <- dyad_census(GRS_sex)$mut
     recip_mut_allsex <- append(recip_mut_allsex, r_mut_allsex)
     r_null_allsex <- dyad_census(GRS_sex)$null
     recip_null_allsex <- append(recip_null_allsex, r_null_allsex)
     

     # set network layout as locations
     lay_sex <- matrix(c(V(GRS_sex)$long, V(GRS_sex)$lat), ncol=2)

     pdf(paste0("../Results/Networks/network_",x))
     # read in and plot a shapefile of Australia
     aus <- readOGR("../Data/AU_shapefiles","gadm36_AUS_2")
     aus <- plot(aus, xlim = c(min(att$Longitude1), max(att$Longitude1)), 
               ylim = c(min(att$Latitude1), max(att$Latitude1)))

     # plot the network onto map
     plot(GRS_sex, layout=lay_sex, vertex.size=1, vertex.label = NA, 
          vertex.frame.color='black', edge.arrow.size = 0.1, 
          edge.curved=-0.4, add=TRUE, rescale=FALSE)
     dev.off()

}
# combine sex network metrics
metrics_allsex <- cbind(sex, density_allsex, recip_mut_allsex, recip_null_allsex)



##### SPECIES NETWORKS WHOLE RANGE #####

# set empty vectors for metrics
species <- c()
density_allsp <- c()
recip_mut_allsp <- c()
recip_null_allsp <- c()

for(x in unique(sharks$Species)){
     sharks_sp <- sharks[sharks$Species == x,]
     # creates an edge list using the 'from' and 'to' columns for 
     # latitude and longitude
     el_sp <- sharks_sp[,c(22,23)] 
     # omit NAs
     el_sp <- na.omit(el_sp)
     # give time taken for movement
     el_time_sp <- sharks_sp[,c(22,23,21)]
     el_time_sp <- na.omit(el_time_sp)

     # creates a non-directed dataframe
     GRS_sp <- graph.data.frame(el_sp,directed=FALSE) 
     # and turns it into a adjacency matrix
     net_sp <- as_adjacency_matrix(GRS_sp) 
     net_sp <- as.matrix(net_sp)
     GRS_sp <- graph.adjacency(net_sp, mode = "directed", diag = FALSE, 
     weighted = TRUE) 
     # calculates weigthed degree for each node
     # graph.strength(GRS) 

     # match nodes to receiver locations
     poss_sp <- match(V(GRS_sp)$name, att$Name1)
     V(GRS_sp)$long <- att$Longitude1[poss_sp]
     V(GRS_sp)$lat <- att$Latitude1[poss_sp]
     V(GRS_sp)$name <- att$Name1[poss_sp]

     # determine the range for the edge weights
     E(GRS_sp)$width <- sqrt(E(GRS_sp)$weight)
     # network metrics
     species <- append(species,x)
     d_allsp <- ecount(GRS_sp)/(vcount(GRS_sp)* (vcount(GRS_sp)-1))
     density_allsp <- append(density_allsp, d_allsp)
     r_mut_allsp <- dyad_census(GRS_sp)$mut
     recip_mut_allsp <- append(recip_mut_allsp, r_mut_allsp)
     r_null_allsp <- dyad_census(GRS_sp)$null
     recip_null_allsp <- append(recip_null_allsp, r_null_allsp)
     

     # set network layout as locations
     lay_sp <- matrix(c(V(GRS_sp)$long, V(GRS_sp)$lat), ncol=2)

     pdf(paste0("../Results/Networks/network_",x))
     # read in and plot a shapefile of Australia
     aus <- readOGR("../Data/AU_shapefiles","gadm36_AUS_2")
     aus <- plot(aus, xlim = c(min(att$Longitude1), max(att$Longitude1)), 
               ylim = c(min(att$Latitude1), max(att$Latitude1)))

     # plot the network onto map
     plot(GRS_sp, layout=lay_sp, vertex.size=1, vertex.label = NA, 
          vertex.frame.color='black', vertex.color='gold', 
          edge.curved=-0.4, add=TRUE, rescale=FALSE)
     dev.off()

}

# combine species network metrics
metrics_allsp <- cbind(species, density_allsp, recip_mut_allsp, recip_null_allsp)













##### POPULATION LEVEL NETWORK FOR NINGALOO #####

### Non-proportional simple edge count matrices

# subset for movements within ningaloo only
nin <- subset(sharks, Latitude > -24)

# creates an edge list using the 'from' and 'to' columns for latitude and longitude
el <- nin[,c(22,23)] 
# omit NAs
el <- na.omit(el)
# give time taken for movement
el_time <- nin[,c(22,23,21)]
el_time <- na.omit(el_time)

# creates a non-directed dataframe
G <- graph.data.frame(el,directed=FALSE) 
# and turns it into a adjacency matrix
net <- as_adjacency_matrix(G) 
net <- as.matrix(net)
GRS_nin <- graph.adjacency(net, mode = "directed", diag = FALSE, weighted = TRUE) 
# calculates weigthed degree for each node
# graph.strength(GRS) 

### Visualisations 

# Location attributes
# receiver attribute file needed with lon/lat coords
att <- read.csv("../Data/receivers.csv", header = TRUE)
att_nin <- subset(att, Latitude1 > -24)
coordinates(att_nin) <- c("Longitude1","Latitude1")
# plot receiver locations
# plot(att, pch=20, cex=1, col="gold")

# set names as characters for matching
att_nin$Name1 <- as.character(att_nin$Name1)
# match nodes to receiver locations
poss <- match(V(GRS_nin)$name, att_nin$Name1)
V(GRS_nin)$long <- att_nin$Longitude1[poss]
V(GRS_nin)$lat <- att_nin$Latitude1[poss]
V(GRS_nin)$name <- att_nin$Name1[poss]

# determine the range for the edge weights
E(GRS_nin)$width <- sqrt(E(GRS_nin)$weight)
# network metrics
d_nin <- ecount(GRS_nin)/(vcount(GRS_nin)* (vcount(GRS_nin)-1))
r_mut_nin <- dyad_census(GRS_nin)$mut
r_null_nin <- dyad_census(GRS_nin)$null
metrics_nin <- c("ningaloo",d_nin,r_mut_nin,r_null_nin)

# set network layout as locations
lay <- matrix(c(V(GRS_nin)$long, V(GRS_nin)$lat), ncol=2)

# # read in and plot a shapefile of Australia
# aus <- readOGR("../Data/AU_shapefiles","gadm36_AUS_1")
# aus <- plot(aus, xlim = c(min(att_nin$Longitude1), max(att_nin$Longitude1)), 
#             ylim = c(min(att_nin$Latitude1), max(att_nin$Latitude1)+2))

# # plot the network onto map
# population_network_map <- plot(GRS_nin, layout=lay, vertex.size=1, vertex.label = NA, 
#      vertex.frame.color='black', edge.curved=-0.1, edge.arrow.size = 0.1, add=TRUE, rescale=FALSE)










##### MALE VS FEMALE NETWORKS NINGALOO #####

# set empty vectors for metrics
sex_nin <- c()
density_ninsex <- c()
recip_mut_ninsex <- c()
recip_null_ninsex <- c()

for(x in unique(nin$Sex)){
     nin_sex <- nin[nin$Sex == x,]
     # creates an edge list using the 'from' and 'to' columns for 
     #latitude and longitude
     el_sex <- nin_sex[,c(22,23)] 
     # omit NAs
     el_sex <- na.omit(el_sex)
     # give time taken for movement
     el_time_sex <- nin_sex[,c(22,23,21)]
     el_time_sex <- na.omit(el_time_sex)

     # creates a non-directed dataframe
     GRS_sexnin <- graph.data.frame(el_sex,directed=FALSE) 
     # and turns it into a adjacency matrix
     net_sex <- as_adjacency_matrix(GRS_sexnin) 
     net_sex <- as.matrix(net_sex)
     GRS_sexnin <- graph.adjacency(net_sex, mode = "directed", diag = FALSE, 
     weighted = TRUE) 
     # calculates weigthed degree for each node
     # graph.strength(GRS) 

     # match nodes to receiver locations
     poss_sex <- match(V(GRS_sexnin)$name, att_nin$Name1)
     V(GRS_sexnin)$long <- att_nin$Longitude1[poss_sex]
     V(GRS_sexnin)$lat <- att_nin$Latitude1[poss_sex]
     V(GRS_sexnin)$name <- att_nin$Name1[poss_sex]

     # determine the range for the edge weights
     E(GRS_sexnin)$width <- sqrt(E(GRS_sexnin)$weight)
     # network metrics
     sex <- append(sex,x)
     d_ninsex <- ecount(GRS_sexnin)/(vcount(GRS_sexnin)* (vcount(GRS_sexnin)-1))
     density_ninsex <- append(density_ninsex, d_ninsex)
     r_mut_ninsex <- dyad_census(GRS_sexnin)$mut
     recip_mut_ninsex <- append(recip_mut_ninsex, r_mut_ninsex)
     r_null_ninsex <- dyad_census(GRS_sexnin)$null
     recip_null_ninsex <- append(recip_null_ninsex, r_null_ninsex)
     

     # set network layout as locations
     lay_sex <- matrix(c(V(GRS_sexnin)$long, V(GRS_sexnin)$lat), ncol=2)

     pdf(paste0("../Results/Networks/network_",x))
     # read in and plot a shapefile of Australia
     aus <- readOGR("../Data/AU_shapefiles","gadm36_AUS_2")
     aus <- plot(aus, xlim = c(min(att_nin$Longitude1), max(att_nin$Longitude1)), 
               ylim = c(min(att_nin$Latitude1), max(att_nin$Latitude1)))

     # plot the network onto map
     plot(GRS_sexnin, layout=lay_sex, vertex.size=1, vertex.label = NA, 
          vertex.frame.color='black', edge.arrow.size = 0.1, 
          edge.curved=-0.4, add=TRUE, rescale=FALSE)
     dev.off()

}
# combine sex network metrics
metrics_ninsex <- cbind(sex, density_ninsex, recip_mut_ninsex, recip_null_ninsex)



##### SPECIES NETWORKS FOR NINGALOO #####

# set empty vectors for metrics
species <- c()
density_ninsp <- c()
recip_mut_ninsp <- c()
recip_null_ninsp <- c()

for(x in unique(nin$Species)){
     nin_sp <- nin[nin$Species == x,]
     # creates an edge list using the 'from' and 'to' columns for 
     # latitude and longitude
     el_sp <- nin_sp[,c(22,23)] 
     # omit NAs
     el_sp <- na.omit(el_sp)
     # give time taken for movement
     el_time_sp <- nin_sp[,c(22,23,21)]
     el_time_sp <- na.omit(el_time_sp)

     # creates a non-directed dataframe
     GRS_spnin <- graph.data.frame(el_sp,directed=FALSE) 
     # and turns it into a adjacency matrix
     net_sp <- as_adjacency_matrix(GRS_spnin) 
     net_sp <- as.matrix(net_sp)
     GRS_spnin <- graph.adjacency(net_sp, mode = "directed", diag = FALSE, 
     weighted = TRUE) 
     # calculates weigthed degree for each node
     # graph.strength(GRS) 

     # match nodes to receiver locations
     poss_sp <- match(V(GRS_spnin)$name, att_nin$Name1)
     V(GRS_spnin)$long <- att_nin$Longitude1[poss_sp]
     V(GRS_spnin)$lat <- att_nin$Latitude1[poss_sp]
     V(GRS_spnin)$name <- att_nin$Name1[poss_sp]

     # determine the range for the edge weights
     E(GRS_spnin)$width <- sqrt(E(GRS_spnin)$weight)
     # network metrics
     species <- append(species,x)
     d_ninsp <- ecount(GRS_spnin)/(vcount(GRS_spnin)* (vcount(GRS_spnin)-1))
     density_ninsp <- append(density_ninsp, d_ninsp)
     r_mut_ninsp <- dyad_census(GRS_spnin)$mut
     recip_mut_ninsp <- append(recip_mut_ninsp, r_mut_ninsp)
     r_null_ninsp <- dyad_census(GRS_spnin)$null
     recip_null_ninsp <- append(recip_null_ninsp, r_null_ninsp)
     

     # set network layout as locations
     lay_sp <- matrix(c(V(GRS_spnin)$long, V(GRS_spnin)$lat), ncol=2)

     pdf(paste0("../Results/Networks/network_",x))
     # read in and plot a shapefile of Australia
     aus <- readOGR("../Data/AU_shapefiles","gadm36_AUS_2")
     aus <- plot(aus, xlim = c(min(att_nin$Longitude1), max(att_nin$Longitude1)), 
               ylim = c(min(att_nin$Latitude1), max(att_nin$Latitude1)))

     # plot the network onto map
     plot(GRS_spnin, layout=lay_sp, vertex.size=1, vertex.label = NA, 
          vertex.frame.color='black', vertex.color='gold', 
          edge.curved=-0.4, add=TRUE, rescale=FALSE)
     dev.off()

}

# combine species network metrics
metrics_ninsp <- cbind(species, density_ninsp, recip_mut_ninsp, recip_null_ninsp)

# combine all population level network metrics
total_metrics <- rbind(metrics_all, metrics_allsex, metrics_allsp, metrics_nin, 
     metrics_ninsex, metrics_ninsp)









##### INDIVIDUAL NETWORKS FOR NINGALOO #####


# set empty vectors for metrics
codes <- c()
density_ninind <- c()
recip_mut_ninind <- c()
recip_null_ninind <- c()

for(x in unique(nin$TagCode)){
     nin_ind <- nin[nin$TagCode == x,]
     # creates an edge list using the 'from' and 'to' columns for latitude and longitude
     el_ind <- nin_ind[,c(22,23)] 
     # omit NAs
     el_ind <- na.omit(el_ind)
     if(length(el_ind$From) != 0){
     # give time taken for movement
     el_time_ind <- nin_ind[,c(22,23,21)]
     el_time_ind <- na.omit(el_time_ind)

     # creates a non-directed dataframe
     GRS_indnin <- graph.data.frame(el_ind,directed=FALSE) 
     # and turns it into a adjacency matrix
     net_ind <- as_adjacency_matrix(GRS_indnin) 
     net_ind <- as.matrix(net_ind)
     GRS_indnin <- graph.adjacency(net_ind, mode = "directed", diag = FALSE, weighted = TRUE) 
     # calculates weigthed degree for each node
     # graph.strength(GRS) 

     # match nodes to receiver locations
     poss_ind <- match(V(GRS_indnin)$name, att_nin$Name1)
     V(GRS_indnin)$long <- att_nin$Longitude1[poss_ind]
     V(GRS_indnin)$lat <- att_nin$Latitude1[poss_ind]
     V(GRS_indnin)$name <- att_nin$Name1[poss_ind]

     # determine the range for the edge weights
     E(GRS_indnin)$width <- sqrt(E(GRS_indnin)$weight)
     # network metrics
     codes <- append(codes,x)
     d_ninind <- ecount(GRS_indnin)/(vcount(GRS_indnin)* (vcount(GRS_indnin)-1))
     density_ninind <- append(density_ninind, d_ninind)
     r_mut_ninind <- dyad_census(GRS_indnin)$mut
     recip_mut_ninind <- append(recip_mut_ninind, r_mut_ninind)
     r_null_ninind <- dyad_census(GRS_indnin)$null
     recip_null_ninind <- append(recip_null_ninind, r_null_ninind)
     }else{}

     # plot if required
     # # set network layout as locations
     # lay_ind <- matrix(c(V(GRS_indnin)$long, V(GRS_indnin)$lat), ncol=2)

     # pdf(paste0("../Results/Networks/network_",x))
     # # read in and plot a shapefile of Australia
     # aus <- readOGR("../Data/AU_shapefiles","gadm36_AUS_1")
     # aus <- plot(aus, xlim = c(min(att_nin$Longitude1), max(att_nin$Longitude1)), 
     #           ylim = c(min(att_nin$Latitude1), max(att_nin$Latitude1)))

     # # plot the network onto map
     # plot(GRS_indnin, layout=lay_ind, vertex.size=1, vertex.label = NA, 
     #      vertex.frame.color='black', vertex.color='gold', 
     #      edge.curved=-0.4, add=TRUE, rescale=FALSE)
     # dev.off()

}

# combine metrics to join to overall metrics file
ind_metrics <- cbind(codes, density_ninind, recip_mut_ninind, recip_null_ninind)
total_network_metrics <- rbind(total_metrics,ind_metrics)


# networks for individuals within their residential area
# read in attribute data to subset for required sharks
ind_att <- read.csv("../Data/shark_attributes.csv", header = TRUE)

# bind metrics
network_metrics <- data.frame(ind_metrics)
colnames(network_metrics) <- c("Transmitter.Name","Network_Density","Mutual_recip","Non_recip")
# bind to attributes file
ind_metrics <- left_join(ind_att, network_metrics, by = "Transmitter.Name")












##### INDIVIDUAL NETWORKS FOR NINGALOO PER YEAR #####



# for(i in unique(year(nin$DateTime.local))){
#      nin_year <- subset(nin, year(nin$DateTime.local)==i)
#      # set empty vectors for metrics
#      codes <- c()
#      density_ninind <- c()

#      for(x in unique(nin$TagCode)){
#           nin_ind <- nin_year[nin_year$TagCode == x,]
#           # creates an edge list using the 'from' and 'to' columns for latitude and longitude
#           el_ind <- nin_ind[,c(22,23)] 
#           # omit NAs
#           el_ind <- na.omit(el_ind)
#           if(length(el_ind$From) != 0){
#                # give time taken for movement
#                el_time_ind <- nin_ind[,c(22,23,21)]
#                el_time_ind <- na.omit(el_time_ind)

#                # creates a non-directed dataframe
#                GRS_indnin <- graph.data.frame(el_ind,directed=FALSE) 
#                # and turns it into a adjacency matrix
#                net_ind <- as_adjacency_matrix(GRS_indnin) 
#                net_ind <- as.matrix(net_ind)
#                GRS_indnin <- graph.adjacency(net_ind, mode = "directed", diag = FALSE, weighted = TRUE) 
#                # calculates weigthed degree for each node
#                # graph.strength(GRS) 

#                # match nodes to receiver locations
#                poss_ind <- match(V(GRS_indnin)$name, att_nin$Name1)
#                V(GRS_indnin)$long <- att_nin$Longitude1[poss_ind]
#                V(GRS_indnin)$lat <- att_nin$Latitude1[poss_ind]
#                V(GRS_indnin)$name <- att_nin$Name1[poss_ind]

#                # determine the range for the edge weights
#                E(GRS_indnin)$width <- sqrt(E(GRS_indnin)$weight)
#                # network metrics
#                codes <- append(codes,x)
#                d_ninind <- ecount(GRS_indnin)/(vcount(GRS_indnin)* (vcount(GRS_indnin)-1))
#                density_ninind <- append(density_ninind, d_ninind)
#           }else{}
#      }
#      # bind network metrics
#      m <- cbind(codes, density_ninind)
#      nm <- data.frame(m)
#      colnames(nm) <- c("Transmitter.Name",paste0("Network_Density_",i))
#      # join to original attributes
#      ind_metrics <- left_join(ind_metrics, nm, by = "Transmitter.Name")

# }







##### INDIVIDUAL NETWORKS FOR NINGALOO PER SEASON #####

# create month field
nin <- nin %>% mutate(Month=month(DateTime.local))
# order by month
nin <- nin[order(nin$Month),]

# make data frame of detection frequency
months <- data.frame(table(nin$Month))
summer1 <- rep("Summer",sum(months$Freq[1:2]))
autumn <- rep("Autumn",sum(months$Freq[3:5]))
winter <- rep("Winter",sum(months$Freq[6:8]))
spring <- rep("Spring",sum(months$Freq[9:11]))
summer2 <- rep("Summer",sum(months$Freq[12]))
nin$Seasons <- c(summer1,autumn,winter,spring,summer2)



for(i in unique(nin$Seasons)){
     nin_season <- subset(nin, nin$Seasons ==i)
     # set empty vectors for metrics
     codes <- c()
     density_ninind <- c()

     for(x in unique(nin$TagCode)){
          nin_ind <- nin_season[nin_season$TagCode == x,]
          # creates an edge list using the 'from' and 'to' columns for latitude and longitude
          el_ind <- nin_ind[,c(22,23)] 
          # omit NAs
          el_ind <- na.omit(el_ind)
          if(length(el_ind$From) != 0){
               # give time taken for movement
               el_time_ind <- nin_ind[,c(22,23,21)]
               el_time_ind <- na.omit(el_time_ind)

               # creates a non-directed dataframe
               GRS_indnin <- graph.data.frame(el_ind,directed=FALSE) 
               # and turns it into a adjacency matrix
               net_ind <- as_adjacency_matrix(GRS_indnin) 
               net_ind <- as.matrix(net_ind)
               GRS_indnin <- graph.adjacency(net_ind, mode = "directed", diag = FALSE, weighted = TRUE) 
               # calculates weigthed degree for each node
               # graph.strength(GRS) 

               # match nodes to receiver locations
               poss_ind <- match(V(GRS_indnin)$name, att_nin$Name1)
               V(GRS_indnin)$long <- att_nin$Longitude1[poss_ind]
               V(GRS_indnin)$lat <- att_nin$Latitude1[poss_ind]
               V(GRS_indnin)$name <- att_nin$Name1[poss_ind]

               # determine the range for the edge weights
               E(GRS_indnin)$width <- sqrt(E(GRS_indnin)$weight)
               # network metrics
               codes <- append(codes,x)
               d_ninind <- ecount(GRS_indnin)/(vcount(GRS_indnin)* (vcount(GRS_indnin)-1))
               density_ninind <- append(density_ninind, d_ninind)
          }else{}
     }
     # bind network metrics
     n <- cbind(codes, density_ninind)
     nm <- data.frame(n)
     colnames(nm) <- c("Transmitter.Name",paste0("Network_Density_",i))
     # join to original attributes
     ind_metrics <- left_join(ind_metrics, nm, by = "Transmitter.Name")

}




##### INDIVIDUAL NETWORKS FOR NINGALOO PER TIME OF DAY #####

# add sunset and sunrise times to each detection
nin <- inner_join(nin, ss)
# classify each detection as day or night
nin$daynight <- ifelse(hms(nin$Time.local) > hms(nin$Sunrise) & 
                  hms(nin$Time.local) < hms(nin$Sunset), 'day', 'night')



for(i in unique(nin$daynight)){
     nin_dn <- subset(nin, nin$daynight ==i)
     # set empty vectors for metrics
     codes <- c()
     density_ninind <- c()

     for(x in unique(nin_dn$TagCode)){
          nin_ind <- nin_dn[nin_dn$TagCode == x,]
          # creates an edge list using the 'from' and 'to' columns for latitude and longitude
          el_ind <- nin_ind[,c(22,23)] 
          # omit NAs
          el_ind <- na.omit(el_ind)
          if(length(el_ind$From) != 0){
               # give time taken for movement
               el_time_ind <- nin_ind[,c(22,23,21)]
               el_time_ind <- na.omit(el_time_ind)

               # creates a non-directed dataframe
               GRS_indnin <- graph.data.frame(el_ind,directed=FALSE) 
               # and turns it into a adjacency matrix
               net_ind <- as_adjacency_matrix(GRS_indnin) 
               net_ind <- as.matrix(net_ind)
               GRS_indnin <- graph.adjacency(net_ind, mode = "directed", diag = FALSE, weighted = TRUE) 
               # calculates weigthed degree for each node
               # graph.strength(GRS) 

               # match nodes to receiver locations
               poss_ind <- match(V(GRS_indnin)$name, att_nin$Name1)
               V(GRS_indnin)$long <- att_nin$Longitude1[poss_ind]
               V(GRS_indnin)$lat <- att_nin$Latitude1[poss_ind]
               V(GRS_indnin)$name <- att_nin$Name1[poss_ind]

               # determine the range for the edge weights
               E(GRS_indnin)$width <- sqrt(E(GRS_indnin)$weight)
               # network metrics
               codes <- append(codes,x)
               d_ninind <- ecount(GRS_indnin)/(vcount(GRS_indnin)* (vcount(GRS_indnin)-1))
               density_ninind <- append(density_ninind, d_ninind)
          }else{}
     }
     # bind network metrics
     n <- cbind(codes, density_ninind)
     nm <- data.frame(n)
     colnames(nm) <- c("Transmitter.Name",paste0("Network_Density_",i))
     # join to original attributes
     ind_metrics <- left_join(ind_metrics, nm, by = "Transmitter.Name")

}




#### SEASON NETWORKS PER INDIVIDUAL - DAYTIME


nin_d <- subset(nin, daynight == "day")
for(i in unique(nin_d$Seasons)){
     nin_season <- subset(nin_d, Seasons ==i)
     # set empty vectors for metrics
     codes <- c()
     density_ninind <- c()

     for(x in unique(nin_season$TagCode)){
          nin_ind <- nin_season[nin_season$TagCode == x,]
          # creates an edge list using the 'from' and 'to' columns for latitude and longitude
          el_ind <- nin_ind[,c(22,23)] 
          # omit NAs
          el_ind <- na.omit(el_ind)
          if(length(el_ind$From) != 0){
               # give time taken for movement
               el_time_ind <- nin_ind[,c(22,23,21)]
               el_time_ind <- na.omit(el_time_ind)

               # creates a non-directed dataframe
               GRS_indnin <- graph.data.frame(el_ind,directed=FALSE) 
               # and turns it into a adjacency matrix
               net_ind <- as_adjacency_matrix(GRS_indnin) 
               net_ind <- as.matrix(net_ind)
               GRS_indnin <- graph.adjacency(net_ind, mode = "directed", diag = FALSE, weighted = TRUE) 
               # calculates weigthed degree for each node
               # graph.strength(GRS) 

               # match nodes to receiver locations
               poss_ind <- match(V(GRS_indnin)$name, att_nin$Name1)
               V(GRS_indnin)$long <- att_nin$Longitude1[poss_ind]
               V(GRS_indnin)$lat <- att_nin$Latitude1[poss_ind]
               V(GRS_indnin)$name <- att_nin$Name1[poss_ind]

               # determine the range for the edge weights
               E(GRS_indnin)$width <- sqrt(E(GRS_indnin)$weight)
               # network metrics
               codes <- append(codes,x)
               d_ninind <- ecount(GRS_indnin)/(vcount(GRS_indnin)* (vcount(GRS_indnin)-1))
               density_ninind <- append(density_ninind, d_ninind)
          }else{}
     }
     # bind network metrics
     n <- cbind(codes, density_ninind)
     nm <- data.frame(n)
     colnames(nm) <- c("Transmitter.Name",paste0("Network_Density_day_",i))
     # join to original attributes
     ind_metrics <- left_join(ind_metrics, nm, by = "Transmitter.Name")

}



#### SEASON NETWORKS PER INDIVIDUAL - NIGHTTIME


nin_n <- subset(nin, daynight == "night")
for(i in unique(nin_n$Seasons)){
     nin_season <- subset(nin_n, nin_n$Seasons ==i)
     # set empty vectors for metrics
     codes <- c()
     density_ninind <- c()

     for(x in unique(nin_season$TagCode)){
          nin_ind <- nin_season[nin_season$TagCode == x,]
          # creates an edge list using the 'from' and 'to' columns for latitude and longitude
          el_ind <- nin_ind[,c(22,23)] 
          # omit NAs
          el_ind <- na.omit(el_ind)
          if(length(el_ind$From) != 0){
               # give time taken for movement
               el_time_ind <- nin_ind[,c(22,23,21)]
               el_time_ind <- na.omit(el_time_ind)

               # creates a non-directed dataframe
               GRS_indnin <- graph.data.frame(el_ind,directed=FALSE) 
               # and turns it into a adjacency matrix
               net_ind <- as_adjacency_matrix(GRS_indnin) 
               net_ind <- as.matrix(net_ind)
               GRS_indnin <- graph.adjacency(net_ind, mode = "directed", diag = FALSE, weighted = TRUE) 
               # calculates weigthed degree for each node
               # graph.strength(GRS) 

               # match nodes to receiver locations
               poss_ind <- match(V(GRS_indnin)$name, att_nin$Name1)
               V(GRS_indnin)$long <- att_nin$Longitude1[poss_ind]
               V(GRS_indnin)$lat <- att_nin$Latitude1[poss_ind]
               V(GRS_indnin)$name <- att_nin$Name1[poss_ind]

               # determine the range for the edge weights
               E(GRS_indnin)$width <- sqrt(E(GRS_indnin)$weight)
               # network metrics
               codes <- append(codes,x)
               d_ninind <- ecount(GRS_indnin)/(vcount(GRS_indnin)* (vcount(GRS_indnin)-1))
               density_ninind <- append(density_ninind, d_ninind)
          }else{}
     }
     # bind network metrics
     n <- cbind(codes, density_ninind)
     nm <- data.frame(n)
     colnames(nm) <- c("Transmitter.Name",paste0("Network_Density_night_",i))
     # join to original attributes
     ind_metrics <- left_join(ind_metrics, nm, by = "Transmitter.Name")

}



# write metrics to update attributes csv 
write.csv(ind_metrics,"../Data/shark_attributes.csv", row.names = FALSE)