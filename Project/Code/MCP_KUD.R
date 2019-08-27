#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: MCP_KUD.R
# Desc: Calculates and gives option to plot minimum convex polygons (MCPs) 
#       and kernel utilisation distributions for acoustic telemetry data 
#       and builds attribute file for individuals.
# Arguments: None
# Date: 08 Mar 2019

rm(list=ls())
graphics.off()




# required packages
require(tidyverse)
#require(ggmap) # add in if plotting
require(sp)
require(adehabitatHR)
require(rgdal)


# load in centre of activity data
sharks_coa <- read.csv("../Data/sharks_coa.csv", header = TRUE)

##### BASE DETECTION DATA PLOT #####

# # plot raw detection data
# hoi_bbox <- make_bbox(lon = sharks_coa$Longitude.coa, lat = sharks_coa$Latitude.coa, f=0.5)
# hoi_map <- get_map(location = hoi_bbox, source = "google", maptype = "satellite")

# # plots receivers each individual was detected at on map
# sharks_plot <-  ggmap(hoi_map) +
#                 geom_point(data = sharks_coa, mapping = aes(x=Longitude.coa, y=Latitude.coa),
#                 shape = 1, color = 1) +
#                 # add in facet wrap part to generate sep. plot per individual
#                 xlab("Longitude") + ylab("Latitude") + facet_wrap(~`id`, nrow=4)











##### CALCULATING MINIMUM CONVEX POLYGONS FOR TOTAL RANGE #####

# setting specific name to data so original not overwritten
sharks_coa4mcp <- sharks_coa
# convert centre of activity data to spatial object
coordinates(sharks_coa4mcp) <- c("Longitude.coa","Latitude.coa")
# correcting to WGS 84 system required for mcp function
proj4string(sharks_coa4mcp) <- CRS("+init=epsg:4326")
# computing range of individuals using min convex polugon estimator
sharks_mcp <- mcp(sharks_coa4mcp[,"id"])
# write polygons to shape file for further use
writeOGR(sharks_mcp, dsn = "../Results/MCP_KUD_OGR/total_mcp.shp", 
  layer = "total_mcp.shp", driver = "ESRI Shapefile")
# assigning coordinates to each polygon for plotting
mcp_ll <- sharks_mcp %>% fortify()

# # plotting per individual or as whole (depending on previous sharks_plot)
# MCP_plot <- sharks_plot + geom_point(data = data.frame(sharks_coa4mcp), mapping = aes(x = Longitude.coa, y = Latitude.coa),
#                         color = 2, size = 0.2) +
#             geom_polygon(data = sharks_mcp, aes(x=long, y=lat), fill=NA, color = "green")

# transform to coordinate system allowing for calculation of polygon areas in km2
sharks_GDA <- spTransform(sharks_coa4mcp, CRSobj = CRS("+init=epsg:28349"))
# calculate range area of each individual
sharks_area <- mcp.area(sharks_GDA[,"id"], unin = "m", unout = "km2", percent = 100, 
  plot = FALSE)

# convert output into dataframe
mcp_areas <- data.frame(sharks_area)
# convert from wide to long format
mcp_areas <- tidyr::gather(mcp_areas, "Transmitter.Name", "MCP_Area_km2")
# read in raw data to extract attributes for each individual
sharks <- read.csv("../Data/sharkdata.csv", header = TRUE)
# substitute thickskin for sandbar
sharks$Species <- gsub("Thickskin","Sandbar",sharks$Species)
# select required variables
sharks4mcp <- dplyr::select(sharks, Species, TagCode, Sex, FL, ReleaseDate, 
  ReleaseLatitude, ReleaseLongitude)
# ensure column names are consistent
colnames(sharks4mcp) <- c("Species","Transmitter.Name", "Sex", "FL", "ReleaseDate", 
  "ReleaseLatitude", "ReleaseLongitude")
# join attribute data with area
mcp_areas <- plyr::join(mcp_areas, sharks4mcp, by = "Transmitter.Name", 
  match = "first", type = "left")








##### NINGALOO ONLY MCP #####

# Ningaloo shark coa
sharks_coa_nin <- read.csv("../Data/sharks_coa_ningaloo.csv", header = TRUE)

##### BASE DETECTION DATA PLOT #####

# plot raw detection data
# hoi_bbox_nin <- make_bbox(lon = sharks_coa_nin$Longitude.coa, lat = sharks_coa_nin$Latitude.coa, f=0.2)
# hoi_map_nin <- get_map(location = hoi_bbox_nin, source = "google", maptype = "satellite")

# # plots receivers each individual was detected at on map
# sharks_plot_nin <-  ggmap(hoi_map_nin) +
#                 geom_point(data = sharks_coa_nin, mapping = aes(x=Longitude.coa, y=Latitude.coa),
#                 shape = 1, color = 1) +
#                 # add in facet wrap part to generate sep. plot per individual
#                 xlab("Longitude") + ylab("Latitude") + facet_wrap(~`id`, nrow=4)


##### CALCULATING MINIMUM CONVEX POLYGONS FOR NINGALOO #####

# setting specific name to data so original not overwritten
nin_coa4mcp <- sharks_coa_nin
# convert centre of activity data to spatial object
coordinates(nin_coa4mcp) <- c("Longitude.coa","Latitude.coa")
# correcting to WGS 84 system required for mcp function
proj4string(nin_coa4mcp) <- CRS("+init=epsg:4326")
# computing range of individuals using min convex polugon estimator
nin_mcp <- mcp(nin_coa4mcp[,"id"])
# write polygons to shape file for further use
writeOGR(nin_mcp, dsn = "../Results/MCP_KUD_OGR/nin_mcp.shp", 
  layer = "nin_mcp.shp", driver = "ESRI Shapefile")
# assigning coordinates to each polygon for plotting
mcp_ll_nin <- nin_mcp %>% fortify()

# # plotting per individual or as whole (depending on previous sharks_plot)
# MCP_nin_plot <- sharks_plot_nin + geom_point(data = data.frame(nin_coa4mcp), mapping = aes(x = Longitude.coa, y = Latitude.coa),
#                         color = 2, size = 0.2) +
#             geom_polygon(data = nin_mcp, aes(x=long, y=lat), fill=NA, color = "green")

# transform to coordinate system allowing for calculation of polygon areas in km2
nin_GDA <- spTransform(nin_coa4mcp, CRSobj = CRS("+init=epsg:28349"))
# calculate range area of each individual
nin_area <- mcp.area(nin_GDA[,"id"], unin = "m", unout = "km2", 
  percent = 100, plot = FALSE)

# build datafrane for ningaloo mcp areas
nin_data <- data.frame(nin_area)
# convert from wide to long format
nin_data <- tidyr::gather(nin_data, "Transmitter.Name", "NinMCP_Area_km2")
# join to attributes dataframe 
mcp_areas <- left_join(mcp_areas, nin_data, by = "Transmitter.Name")


##### USE NINGALOO MCP TO CALCULATE NINGALOO KERNEL DENSITIES #####

# calculate probability density of individual movements
sharks_KUD <- kernelUD(nin_GDA[,"Transmitter.Name"], h=300, grid = 800)
# calculate kernel areas
sharks_area_KUD <- kernel.area(sharks_KUD, percent = c(50,95), unin = "m", 
  unout = "km2")

# define and transform core range (50%)
core_KUD <- 
  getverticeshr(sharks_KUD, percent = 50) %>%
  spTransform(CRS("+init=epsg:4326"))
writeOGR(core_KUD, dsn = "../Results/MCP_KUD_OGR/nin_core_kud.shp", 
  layer = "nin_core_kud.shp", driver = "ESRI Shapefile")
# define and transform extent range (95%)
extent_KUD <- 
  getverticeshr(sharks_KUD, percent = 95) %>%
  spTransform(CRS("+init=epsg:4326"))
writeOGR(extent_KUD, dsn = "../Results/MCP_KUD_OGR/nin_extent_kud.shp", 
  layer = "nin_extent_kud.shp", driver = "ESRI Shapefile")
# # plot KUD figures
# pdf("../Results/KUD_plots_residential.pdf")
# sharks_plot_nin + geom_point(data = data.frame(sharks_coa_nin), mapping = aes(x = Longitude.coa, y = Latitude.coa),
#                         color = 2, size = 0.2) +
#              geom_polygon(data = extent_KUD, aes(x = long, y=lat, group=group),
#                           fill = "white", color = "white", alpha = 0.1) +
#              geom_polygon(data = core_KUD, aes(x = long, y=lat, group=group),
#                           fill = "red", color = "red", alpha = 0.4)
# graphics.off()


# KUD areas:
KUD_areas <- data.frame(sharks_area_KUD)
KUD_areas_50 <- KUD_areas[1,]
KUD_areas_95 <- KUD_areas[2,]
# convert from wide to long format
KUD_areas_50 <- tidyr::gather(KUD_areas_50, "Transmitter.Name", "Core_KUD_km2")
KUD_areas_95 <- tidyr::gather(KUD_areas_95, "Transmitter.Name", "Extent_KUD_km2")
# combine to single dataframe
KUD_areas <- dplyr::left_join(KUD_areas_50,KUD_areas_95,by = "Transmitter.Name")
# add to attribute data file
mcp_areas <- left_join(mcp_areas, KUD_areas, by = "Transmitter.Name")









##### IDENTIFYING WHICH SHARKS MIGRATE BETWEEN NORTH AND SOUTH #####

# those that enter the northern range are given by:
north_transmitters <- unique(sharks_coa$Transmitter.Name[sharks_coa$Latitude.coa > -24])
# convert to dataframe to merge with area dataset
north_transmitters <- data.frame(north_transmitters)
# set column to correspond to other dataset for merging 
colnames(north_transmitters) <- "Transmitter.Name"
# inner join to exclude any individuals that aren't present in the northern range
mcp_areas_N <- dplyr::inner_join(mcp_areas,north_transmitters,by = "Transmitter.Name")
# sorting the sharks with enough movements into migratory and non migratory
migratory_sharks <- mcp_areas_N$Transmitter.Name[mcp_areas_N$MCP_Area_km2 > 20000]
# those found in Ningaloo
non_migratory_sharks_N <- mcp_areas_N$Transmitter.Name[mcp_areas_N$MCP_Area_km2 < 20000]
# those only found in the south
non_migratory_sharks_S <- mcp_areas$Transmitter[!mcp_areas$Transmitter %in% 
  c(migratory_sharks,non_migratory_sharks_N)]
X <- c(migratory_sharks,non_migratory_sharks_N,non_migratory_sharks_S)
# generating values for migration dataframe
a <- rep("migratory", length(migratory_sharks))
b <- rep("non_migratory_N", length(non_migratory_sharks_N))
c <- rep("non_migratory_S", length(non_migratory_sharks_S))
Migratory <- c(a,b,c)
# build dataframe of sharks with migratory statuses 
migration_status <- data.frame(cbind(X,Migratory))
colnames(migration_status) <- c("Transmitter.Name","Migratory.Status")
# join with attributes data 
migration_status <- dplyr::left_join(mcp_areas,migration_status, 
  by="Transmitter.Name")


##### COMPILE ATTRIBUTE FILE #####

# add in those with too few movements to calculate mcp - for completeness of 
# attribute file
few <- read.csv("../Data/attributes_toofew.csv", header = TRUE)
# make dataframe of codes and populate area field with NA - as too small to 
# calculate
codes_few <- data.frame(unique(few$Transmitter.Name))
areas_few <- rep(NA,length(codes_few))
nin_areas_few <- rep(NA,length(codes_few))
core <- rep(NA,length(codes_few))
extent <- rep(NA,length(codes_few))
few_att <- cbind(codes_few,areas_few,nin_areas_few,core,extent)
# set column names so consistant with migratory data frame
colnames(few_att) <- c("Transmitter.Name", "MCP_Area_km2", "NinMCP_Area_km2",
  "Core_KUD_km2","Extent_KUD_km2")
# join with attributes from shark data
few_att <- plyr::join(few_att,sharks4mcp, by = "Transmitter.Name", 
  match = "first", type = "left")
# create a migration status field, populated with NAs and bind to data
Migratory.Status <- rep(NA,length(codes_few[,1]))
few_att <- cbind(few_att,Migratory.Status)
# join attributes of these individuals to those with coa areas
migration_status <- rbind(migration_status,few_att)

# identifying those tagged outside of rest of movements
# create new column calculating the difference between release location and detections
sharks$difference <- abs(sharks$ReleaseLatitude - sharks$Latitude)
# min latitude difference to have moved from north to/from south = 6.7 degrees
# subset sharks that have difference greater than this
mig <- subset(sharks, difference >= 6.7)
# build dataframes of tagcodes to match
mig_sharks <- data.frame(unique(mig$TagCode))
colnames(mig_sharks) <- "TagCode"
non_mig_N <- data.frame(c(non_migratory_sharks_N,non_migratory_sharks_S,
  as.character(unique(few$Transmitter.Name))))
colnames(non_mig_N) <- "TagCode"
# identify migratory individuals from tagging
to_change <- c(inner_join(non_mig_N,mig_sharks, by = "TagCode"))
# switch to migratory
for(x in 1:length(migration_status$Transmitter.Name)){
    if(migration_status$Transmitter.Name[x] %in% to_change[[1]] == TRUE){
      migration_status$Migratory.Status[x] <- "migratory"
    }else{}
}

# write attributes file to csv
write.csv(migration_status, "../Data/shark_attributes.csv", row.names=FALSE)






