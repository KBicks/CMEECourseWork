#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: MCP.R
# Desc: Calculates and gives option to plot minimum convex polygons (MCPs) 
#       for acoustic telemetry data and builds attribute file for individuals.
# Arguments: None
# Date: 08 Mar 2019

rm(list=ls())
graphics.off()

# required packages
require(tidyverse)
require(sp)
require(adehabitatHR)
require(rgdal)



##### NINGALOO SUBSETS MCP #####

# read in current attributes file
att <- read.csv("../Data/shark_attributes.csv", header = TRUE)




##### CALCULATING MINIMUM CONVEX POLYGONS AND KUD FOR NINGALOO SUBSETS #####

# create list of subset files
path <- "../Data/COA/"
files <- list.files(path=path, pattern="*.csv")

# calculate MCP and KUD for each subset
for(x in files){
  coa_file <- read.csv(paste0("../Data/COA/",x), header = TRUE)
  # setting specific name to data so original not overwritten
  nin_coa4mcp <- coa_file
  # convert centre of activity data to spatial object
  coordinates(nin_coa4mcp) <- c("Longitude.coa","Latitude.coa")
  # correcting to WGS 84 system required for mcp function
  proj4string(nin_coa4mcp) <- CRS("+init=epsg:4326")
  # computing range of individuals using min convex polygon estimator
  nin_mcp_sub <- mcp(nin_coa4mcp[,"id"])
  name_sub <- strsplit(x,".csv")
  name_sub <- strsplit(name_sub[[1]], "sharks_coa_")[[1]][2]
  # write to OGR shapefile for plotting later
  writeOGR(nin_mcp_sub, dsn = paste0("../Results/MCP_KUD_OGR/nin_mcp_",name_sub,".shp"), 
            layer = paste0("nin_mcp",name_sub[[1]],".shp"), driver = "ESRI Shapefile")
  # assigning coordinates to each polygon for plotting
  mcp_ll_nin <- nin_mcp_sub %>% fortify()
  # transform to coordinate system allowing for calculation of polygon areas in km2
  nin_GDA <- spTransform(nin_coa4mcp, CRSobj = CRS("+init=epsg:28349"))
  # calculate range area of each individual
  nin_area <- mcp.area(nin_GDA[,"id"], unin = "m", unout = "km2", percent = 100, 
    plot = FALSE)
  # build datafrane for ningaloo mcp areas
  nin_data <- data.frame(nin_area)
  # convert from wide to long format
  nin_data <- tidyr::gather(nin_data, "Transmitter.Name", "X")
  # set column name to appropriate subset
  colnames(nin_data)[2] <- paste0("MCP_area_", name_sub)
  att <- left_join(att, nin_data, by = "Transmitter.Name")

  ### Calculate KUD

  # calculate probability density of individual movements
  sharks_KUD <- kernelUD(nin_GDA[,"Transmitter.Name"], h=300, grid = 800)
  # calculate kernel areas
  sharks_area_KUD <- kernel.area(sharks_KUD, percent = 50, unin = "m", unout = "km2")
  # define and transform core range (50%)
  core_KUD <- getverticeshr(sharks_KUD, percent = 50) %>% 
    spTransform(CRS("+init=epsg:4326"))
  # write to OGR file
  writeOGR(core_KUD, dsn = paste0("../Results/MCP_KUD_OGR/core_kud_",name_sub,".shp"),
           layer = paste0("core_kud_",name_sub,".shp"), driver = "ESRI Shapefile")
  # KUD areas:
  KUD_areas <- data.frame(sharks_area_KUD)
  # convert from wide to long format
  KUD_areas <- tidyr::gather(KUD_areas, "Transmitter.Name", "X")
  # change column name to appropriate subset
  colnames(KUD_areas)[2] <- paste0("core_KUD_", name_sub)
  # add to attribute data file
  att <- left_join(att, KUD_areas, by = "Transmitter.Name")

}

# save updated attribute file
write.csv(att, "../Data/shark_attributes.csv", row.names = FALSE)