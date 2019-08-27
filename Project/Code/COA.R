#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: COA.R
# Desc: Calculates centre of activity for shark populations.
# Arguments: None
# Date: 01 Mar 2019

rm(list=ls())
graphics.off()

require(tidyverse)
require(data.table)
require(lubridate)
require(VTrack)

# read in dataframes
sharks <- read.csv("../Data/sharkdata.csv", header=TRUE, na.strings = c("","NA"))
ss <- read.csv("../Data/sunrise_sunset.csv", header = TRUE)

# convert to ymd hms format (POSIXct)
sharks$DateTime <-  sharks$DateTime.local %>% 
                          ymd_hms(tz = "Australia/Perth") %>%
                          with_tz(tzone = "Australia/Perth")

# alter field names to fit with VTrack package format
sharks <- 
  sharks %>%
  mutate(Transmitter = TagCode.original) %>%
  mutate(Transmitter.Name = TagCode) %>%
  mutate(id = Transmitter.Name) %>%
  mutate(Transmitter.Serial = as.character(sharks$Name1)) %>%
  mutate(Sensor.Value = rep(1, length(sharks$TagCode))) %>%
  mutate(Sensor.Unit = rep("m",length(sharks$TagCode))) %>%
  dplyr::select(-DateTime.local)

# select required fields for calculating center of activity
sharks <- sharks %>% dplyr::select(Species,Sex,Latitude,Longitude, DateTime,
                      Transmitter,Transmitter.Name,Transmitter.Serial, 
                      Sensor.Value, Sensor.Unit,id, Time.local)

# change species name from Thickskin to Sandbar (thickskin is a synonym)
sharks$Species <- gsub("Thickskin","Sandbar",sharks$Species)

# create month field
sharks <- sharks %>% mutate(Month=month(DateTime))
# order by month
sharks <- sharks[order(sharks$Month),]

# make data frame of detection frequency
months <- data.frame(table(sharks$Month))
summer1 <- rep("Summer",sum(months$Freq[1:2]))
autumn <- rep("Autumn",sum(months$Freq[3:5]))
winter <- rep("Winter",sum(months$Freq[6:8]))
spring <- rep("Spring",sum(months$Freq[9:11]))
summer2 <- rep("Summer",sum(months$Freq[12]))
# add in season field to dataframe
sharks$Season <- c(summer1,autumn,winter,spring,summer2)

# add sunset and sunrise times to each detection
sharks <- inner_join(sharks, ss)
# classify each detection as day or night
sharks$daynight <- ifelse(hms(sharks$Time.local) > hms(sharks$Sunrise) & 
                  hms(sharks$Time.local) < hms(sharks$Sunset), 'day', 'night')

# remove columns used for calculation only
sharks <- sharks %>% dplyr::select(-Time.local,-Sunrise, -Sunset)



##### CALCULATE OVERALL CENTERS OF ACTIVITY #####

# calculate centers of activity using VTrack package
coa_list <- COA(tagdata = sharks, id = "Transmitter.Name", timestep=10)
# bind data into list
sharks_coa <- rbindlist(coa_list) %>% mutate(id = Transmitter.Name)

# to calculate MCPs min of 4 movements per individual
  useable <- c()
  too_few <-c()
  for(i in unique(sharks_coa$Transmitter.Name)){
    n <- subset(sharks_coa, Transmitter.Name == i)
    if(length(unique(n$Transmitter.Serial)) >= 4){
      useable <- append(useable, i)
    }else{
      too_few <- append(too_few, i)
    }
  }
# write unusable to csv file to add later
sharks_few <- subset(sharks_coa, subset = Transmitter.Name %in% too_few)
write.csv(sharks_few, "../Data/attributes_toofew.csv", row.names = FALSE)
# remove those with too few movements
sharks_coa_sub <- subset(sharks_coa, subset = Transmitter.Name %in% useable)
# written to csv as above process slow, easier for further analysis to subset
write.csv(sharks_coa_sub, "../Data/sharks_coa.csv", row.names = FALSE)





##### CALCULATE CENTERS OF ACTIVITY FOR NINGALOO #####

# for analysis of residentital ranges, subset of ningaloo reef movements:
sharks_nin <- subset(sharks, Latitude >-24)
# calculate centers of activity using VTrack package
coa_list_nin <- COA(tagdata = sharks_nin, id = "Transmitter.Name", timestep=10)
# bind data into list
sharks_coa_nin <- rbindlist(coa_list_nin) %>% mutate(id = Transmitter.Name)
# to calculate MCPs min of 4 movements per individual
  useable_nin <- c()
  for(i in unique(sharks_coa_nin$Transmitter.Name)){
    n <- subset(sharks_coa_nin, Transmitter.Name == i)
    if(length(unique(n$Transmitter.Serial)) >= 4){
      useable_nin <- append(useable_nin, i)
    }else{}
  }
sharks_coa_nin <- subset(
    sharks_coa_nin, subset = Transmitter.Name %in% useable_nin)
# write subset to csv file
write.csv(sharks_coa_nin, "../Data/sharks_coa_ningaloo.csv", row.names = FALSE)



##### CALCULATE CENTERS OF ACTIVITY FOR NINGALOO BY SPECIES #####


for(x in unique(sharks_nin$Species)){
  a <- subset(sharks_nin, sharks_nin$Species == x)
  # calculate centers of activity using VTrack package
  coa_list <- COA(tagdata = a, id = "Transmitter.Name", timestep=10)
  # bind data into list
  coa_nin <- rbindlist(coa_list) %>% mutate(id = Transmitter.Name)
  # to calculate MCPs min of 10 movements per individual
  # gives data frame of number of movements per individual
  codes_nin <- data.frame(table(coa_nin$Transmitter.Name))
  # to calculate MCPs min of 4 movements per individual
  useable_nin <- c()
  for(i in unique(coa_nin$Transmitter.Name)){
    n <- subset(coa_nin, Transmitter.Name == i)
    if(length(unique(n$Transmitter.Serial)) >= 4){
      useable_nin <- append(useable_nin, i)
    }else{}
  }
  coa_nin <- subset(coa_nin, subset = Transmitter.Name %in% useable_nin)
  # write subset to csv file
  write.csv(coa_nin, paste0("../Data/COA/sharks_coa_",x,".csv"), 
            row.names = FALSE)
}


# ##### CALCULATE CENTERS OF ACTIVITY FOR NINGALOO BY YEAR #####


# for(x in unique(year(sharks_nin$DateTime))){
#   a <- subset(sharks_nin, year(sharks_nin$DateTime) == x)
#   # calculate centers of activity using VTrack package
#   coa_list <- COA(tagdata = a, id = "Transmitter.Name", timestep=10)
#   # bind data into list
#   coa_nin <- rbindlist(coa_list) %>% mutate(id = Transmitter.Name)
#   # to calculate MCPs min of 10 movements per individual
#   # gives data frame of number of movements per individual
#   codes_nin <- data.frame(table(coa_nin$Transmitter.Name))
#   # to calculate MCPs min of 4 movements per individual
#   useable_nin <- c()
#   for(i in unique(coa_nin$Transmitter.Name)){
#     n <- subset(coa_nin, Transmitter.Name == i)
#     if(length(unique(n$Transmitter.Serial)) >= 4){
#       useable_nin <- append(useable_nin, i)
#     }else{}
#   }
#   coa_nin <- subset(coa_nin, subset = Transmitter.Name %in% useable_nin)
#   # write subset to csv file
#   write.csv(coa_nin, paste0("../Data/COA/sharks_coa_",x,".csv"), row.names = FALSE)
# }




##### CALCULATE CENTERS OF ACTIVITY FOR NINGALOO BY SEASON #####


for(x in unique(sharks_nin$Season)){
  a <- subset(sharks_nin, sharks_nin$Season == x)
  # calculate centers of activity using VTrack package
  coa_list <- COA(tagdata = a, id = "Transmitter.Name", timestep=10)
  # bind data into list
  coa_nin <- rbindlist(coa_list) %>% mutate(id = Transmitter.Name)
  # to calculate MCPs min of 4 movements per individual
  useable_nin <- c()
  for(i in unique(coa_nin$Transmitter.Name)){
    n <- subset(coa_nin, Transmitter.Name == i)
    if(length(unique(n$Transmitter.Serial)) >= 4){
      useable_nin <- append(useable_nin, i)
    }else{}
  }
  # gives data frame of number of movements per individual
  codes_nin <- data.frame(table(coa_nin$Transmitter.Name))
  # useable are those with more than 10 movements
  useable_nin <- codes_nin$Var1[codes_nin$Freq > 10]
  coa_nin <- subset(coa_nin, subset = Transmitter.Name %in% useable_nin)
  # write subset to csv file
  write.csv(coa_nin, paste0("../Data/COA/sharks_coa_season_",x,".csv"), 
            row.names = FALSE)
}





##### CALCULATE CENTERS OF ACTIVITY FOR NINGALOO BY SEASON - DUSKY #####

dus_sharks_nin <- sharks_nin[sharks_nin$Species == "Dusky",]

for(x in unique(dus_sharks_nin$Season)){
  a <- subset(dus_sharks_nin, dus_sharks_nin$Season == x)
  # calculate centers of activity using VTrack package
  coa_list <- COA(tagdata = a, id = "Transmitter.Name", timestep=10)
  # bind data into list
  coa_nin <- rbindlist(coa_list) %>% mutate(id = Transmitter.Name)
  # to calculate MCPs min of 4 movements per individual
  useable_nin <- c()
  for(i in unique(coa_nin$Transmitter.Name)){
    n <- subset(coa_nin, Transmitter.Name == i)
    if(length(unique(n$Transmitter.Serial)) >= 4){
      useable_nin <- append(useable_nin, i)
    }else{}
  }
  # gives data frame of number of movements per individual
  codes_nin <- data.frame(table(coa_nin$Transmitter.Name))
  # useable are those with more than 10 movements
  useable_nin <- codes_nin$Var1[codes_nin$Freq > 10]
  coa_nin <- subset(coa_nin, subset = Transmitter.Name %in% useable_nin)
  # write subset to csv file
  write.csv(coa_nin, paste0("../Data/COA/sharks_coa_season_dus_",x,".csv"), 
            row.names = FALSE)
}




##### CALCULATE CENTERS OF ACTIVITY FOR NINGALOO BY SEASON - SANDBAR #####

san_sharks_nin <- sharks_nin[sharks_nin$Species == "Sandbar",]

for(x in unique(san_sharks_nin$Season)){
  a <- subset(san_sharks_nin, san_sharks_nin$Season == x)
  # calculate centers of activity using VTrack package
  coa_list <- COA(tagdata = a, id = "Transmitter.Name", timestep=10)
  # bind data into list
  coa_nin <- rbindlist(coa_list) %>% mutate(id = Transmitter.Name)
  # to calculate MCPs min of 4 movements per individual
  useable_nin <- c()
  for(i in unique(coa_nin$Transmitter.Name)){
    n <- subset(coa_nin, Transmitter.Name == i)
    if(length(unique(n$Transmitter.Serial)) >= 4){
      useable_nin <- append(useable_nin, i)
    }else{}
  }
  # gives data frame of number of movements per individual
  codes_nin <- data.frame(table(coa_nin$Transmitter.Name))
  # useable are those with more than 10 movements
  useable_nin <- codes_nin$Var1[codes_nin$Freq > 10]
  coa_nin <- subset(coa_nin, subset = Transmitter.Name %in% useable_nin)
  # write subset to csv file
  write.csv(coa_nin, paste0("../Data/COA/sharks_coa_season_san_",x,".csv"), 
            row.names = FALSE)
}









##### CALCULATE CENTERS OF ACTIVITY FOR NINGALOO TIME OF DAY #####

for(x in unique(sharks_nin$daynight)){
  a <- subset(sharks_nin, sharks_nin$daynight == x)
  # calculate centers of activity using VTrack package
  coa_list <- COA(tagdata = a, id = "Transmitter.Name", timestep=10)
  # bind data into list
  coa_nin <- rbindlist(coa_list) %>% mutate(id = Transmitter.Name)
  # to calculate MCPs min of 10 movements per individual
  # gives data frame of number of movements per individual
  codes_nin <- data.frame(table(coa_nin$Transmitter.Name))
  # to calculate MCPs min of 4 movements per individual
  useable_nin <- c()
  for(i in unique(coa_nin$Transmitter.Name)){
    n <- subset(coa_nin, Transmitter.Name == i)
    if(length(unique(n$Transmitter.Serial)) >= 4){
      useable_nin <- append(useable_nin, i)
    }else{}
  }
  coa_nin <- subset(coa_nin, subset = Transmitter.Name %in% useable_nin)
  # write subset to csv file
  write.csv(coa_nin, paste0("../Data/COA/sharks_coa_",x,".csv"), 
            row.names = FALSE)
}




##### CALCULATE CENTERS OF ACTIVITY FOR NINGALOO TIME OF DAY  - DUSKY #####

for(x in unique(dus_sharks_nin$daynight)){
  a <- subset(dus_sharks_nin, dus_sharks_nin$daynight == x)
  # calculate centers of activity using VTrack package
  coa_list <- COA(tagdata = a, id = "Transmitter.Name", timestep=10)
  # bind data into list
  coa_nin <- rbindlist(coa_list) %>% mutate(id = Transmitter.Name)
  # to calculate MCPs min of 10 movements per individual
  # gives data frame of number of movements per individual
  codes_nin <- data.frame(table(coa_nin$Transmitter.Name))
  # to calculate MCPs min of 4 movements per individual
  useable_nin <- c()
  for(i in unique(coa_nin$Transmitter.Name)){
    n <- subset(coa_nin, Transmitter.Name == i)
    if(length(unique(n$Transmitter.Serial)) >= 4){
      useable_nin <- append(useable_nin, i)
    }else{}
  }
  coa_nin <- subset(coa_nin, subset = Transmitter.Name %in% useable_nin)
  # write subset to csv file
  write.csv(coa_nin, paste0("../Data/COA/sharks_coa_dus_",x,".csv"), 
            row.names = FALSE)
}



##### CALCULATE CENTERS OF ACTIVITY FOR NINGALOO TIME OF DAY  - SANDBAR #####

for(x in unique(san_sharks_nin$daynight)){
  a <- subset(san_sharks_nin, san_sharks_nin$daynight == x)
  # calculate centers of activity using VTrack package
  coa_list <- COA(tagdata = a, id = "Transmitter.Name", timestep=10)
  # bind data into list
  coa_nin <- rbindlist(coa_list) %>% mutate(id = Transmitter.Name)
  # to calculate MCPs min of 10 movements per individual
  # gives data frame of number of movements per individual
  codes_nin <- data.frame(table(coa_nin$Transmitter.Name))
  # to calculate MCPs min of 4 movements per individual
  useable_nin <- c()
  for(i in unique(coa_nin$Transmitter.Name)){
    n <- subset(coa_nin, Transmitter.Name == i)
    if(length(unique(n$Transmitter.Serial)) >= 4){
      useable_nin <- append(useable_nin, i)
    }else{}
  }
  coa_nin <- subset(coa_nin, subset = Transmitter.Name %in% useable_nin)
  # write subset to csv file
  write.csv(coa_nin, paste0("../Data/COA/sharks_coa_san_",x,".csv"), 
            row.names = FALSE)
}




