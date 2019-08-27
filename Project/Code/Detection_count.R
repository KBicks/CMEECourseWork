#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: Detection_count.R
# Desc: Calculating number of detections per shark, over
#       time monitored, within Ningaloo reef.
# Arguments: None
# Date: 20 May 2019


rm(list=ls())
graphics.off()


# required packages
require(tidyverse)
require(lubridate)

sharks <- read.csv("../Data/sharkdata.csv", header = TRUE)
nin <- subset(sharks, Latitude > -24)
att <- read.csv("../Data/shark_attributes.csv", header = TRUE)
att_prop <- att %>% dplyr::select(Transmitter.Name, Sex, Species, Migratory.Status)
ss <- read.csv("../Data/sunrise_sunset.csv", header = TRUE)

codes <- c()
for(x in unique(nin$TagCode)){
    a <- subset(nin, TagCode == x)
    if(length(unique(a$DateTime.local)) > 4){
        codes <- append(codes, x)
    }
}

nin <- subset(nin, subset = TagCode %in% codes)

# create month field for Ningaloo
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


# add sunset and sunrise times to each detection
nin <- inner_join(nin, ss)
# classify each detection as day or night
nin$daynight <- ifelse(hms(nin$Time.local) > hms(nin$Sunrise) & 
                  hms(nin$Time.local) < hms(nin$Sunset), 'day', 'night')

# remove columns used for calculation only
nin <- nin %>% dplyr::select(-Sunrise, -Sunset)



##### CALCULATE DETECTIONS PER INDIVIDUAL PER DAY WITHIN DEPTH BANDS #####

# remove detection data where depth is not recorded
nin_det <- nin[!is.na(nin$Depth),]
# subset attribute data for just migration and transmitter name
att_det <- att %>% dplyr::select(Transmitter.Name, Migratory.Status)

# calculate detections per day per 10m depth band
det_data10 <- data.frame(rbind(c(as.character(1:5),6,7)))
colnames(det_data10) <- c("Transmitter.Name","Date","Sex","Season","Species",
"Depth_band10", 
                        "No_Det")
det_data10$No_Det <- as.numeric(det_data10$No_Det)


for(x in unique(nin_det$TagCode)){
    n <- subset(nin_det, TagCode == x)
    for(i in unique(n$Date.local)){
        s <- subset(n, Date.local == i)
        info <- data.frame(x,i,s$Sex[1],s$Seasons[1], s$Species[1])
        s$Depth_bin10 <- as.factor(round(s$Depth+5, -1))
        db10 <- data.frame(table(s$Depth_bin10))
        f <- cbind(info, db10)
        colnames(f) <- c("Transmitter.Name","Date","Sex","Season", "Species", 
        "Depth_band10", 
                        "No_Det")
        det_data10 <- rbind(det_data10,f)
    }
}

det_data10 <- det_data10[-c(1),]
det_data10 <- merge(det_data10, att_det, by.x = "Transmitter.Name", 
by.y = "Transmitter.Name")
write.csv(det_data10,"../Data/detection_perday10.csv", row.names = FALSE)



# calculate detections per day per 25m depth band
det_data25 <- data.frame(rbind(c(as.character(1:5),6,7)))
colnames(det_data25) <- c("Transmitter.Name","Date","Sex","Season","Species",
"Depth_band25", 
                        "No_Det")
det_data25$No_Det <- as.numeric(det_data25$No_Det)


for(x in unique(nin_det$TagCode)){
    n <- subset(nin_det, TagCode == x)
    for(i in unique(n$Date.local)){
        s <- subset(n, Date.local == i)
        info <- data.frame(x,i,s$Sex[1],s$Seasons[1], s$Species[1])
        s$Depth_bin25 <- as.factor(25*round((s$Depth+12)/25))
        db25 <- data.frame(table(s$Depth_bin25))
        f <- cbind(info, db25)
        colnames(f) <- c("Transmitter.Name","Date","Sex","Season", "Species", 
        "Depth_band25", 
                        "No_Det")
        det_data25 <- rbind(det_data25,f)
    }
}

det_data25 <- det_data25[-c(1),]
det_data25 <- merge(det_data25, att_det, by.x = "Transmitter.Name", 
by.y = "Transmitter.Name")
write.csv(det_data25,"../Data/detection_perday25.csv", row.names = FALSE)


## calculating proportions of detections at each depth band
codes <- c()
Depth_band <- c()
Det_total <- c()
total <- c()
for(x in unique(det_data25$Transmitter.Name)){
    a <- subset(det_data25, Transmitter.Name == x)
    tot <- sum(a$No_Det)
    for(i in unique(a$Depth_band25)){
        b <- subset(a, Depth_band25 == i)
        d <- sum(b$No_Det)
        codes <- append(codes, x)
        Depth_band <- append(Depth_band, i)
        Det_total <- append(Det_total, d)
        total <- append(total, tot)
    }
}

# join into single dataframe
prop <- data.frame(cbind(codes, Depth_band, Det_total, total))
colnames(prop) <- c("Transmitter.Name", "Depth_band25", "Det_perDepth", 
"Det_total")
prop$Det_perDepth <- as.numeric(as.character(prop$Det_perDepth))
prop$Det_total <- as.numeric(as.character(prop$Det_total))
prop$Det_prop <- prop$Det_perDepth/prop$Det_total



# proportion of detections at each depth band per season
codes <- c()
se <- c()
Depth_band <- c()
Det_total <- c()
total <- c()
for(x in unique(det_data25$Transmitter.Name)){
    a <- subset(det_data25, Transmitter.Name == x)
    for(n in unique(a$Season)){
        s <- subset(a, Season == n)    
        tot <- sum(s$No_Det)
        for(i in unique(s$Depth_band25)){
            b <- subset(s, Depth_band25 == i)
            d <- sum(b$No_Det)
            codes <- append(codes, x)
            se <- append(se, n)
            Depth_band <- append(Depth_band, i)
            Det_total <- append(Det_total, d)
            total <- append(total, tot)
        }
    }
}

# join into single dataframe
prop_se <- data.frame(cbind(codes, se, Depth_band, Det_total, total))
colnames(prop_se) <- c("Transmitter.Name","Season", "Depth_band25", 
"Det_perDepth", "Det_total")
prop_se$Det_perDepth <- as.numeric(as.character(prop_se$Det_perDepth))
prop_se$Det_total <- as.numeric(as.character(prop_se$Det_total))
prop_se$Det_prop <- prop_se$Det_perDepth/prop_se$Det_total

prop_se <- left_join(prop_se, att_prop, by = "Transmitter.Name")

write.csv(prop_se,"../Data/detprop_season.csv", row.names = FALSE)

# calculate detections per day per 50m depth band
det_data50 <- data.frame(rbind(c(as.character(1:5),6,7)))
colnames(det_data50) <- c("Transmitter.Name","Date","Sex","Season","Species",
"Depth_band50", 
                        "No_Det")
det_data50$No_Det <- as.numeric(det_data50$No_Det)


for(x in unique(nin_det$TagCode)){
    n <- subset(nin_det, TagCode == x)
    for(i in unique(n$Date.local)){
        s <- subset(n, Date.local == i)
        info <- data.frame(x,i,s$Sex[1],s$Seasons[1], s$Species[1])
        s$Depth_bin50 <- as.factor(50*round((s$Depth+25)/50))
        db50 <- data.frame(table(s$Depth_bin50))
        f <- cbind(info, db50)
        colnames(f) <- c("Transmitter.Name","Date","Sex","Season", "Species", 
        "Depth_band50", 
                        "No_Det")
        det_data50 <- rbind(det_data50,f)
    }
}

det_data50 <- det_data50[-c(1),]
det_data50 <- merge(det_data50, att_det, by.x = "Transmitter.Name", 
by.y = "Transmitter.Name")
write.csv(det_data50,"../Data/detection_perday50.csv", row.names = FALSE)



# calculate detections per day
det_data <- data.frame(rbind(c(as.character(1:5),6,7)))
colnames(det_data) <- c("Transmitter.Name","Date","Sex","Season","Species","Depth", 
                        "No_Det")
det_data$No_Det <- as.numeric(det_data$No_Det)


for(x in unique(nin_det$TagCode)){
    n <- subset(nin_det, TagCode == x)
    for(i in unique(n$Date.local)){
        s <- subset(n, Date.local == i)
        info <- data.frame(x,i,s$Sex[1],s$Seasons[1], s$Species[1])
        db <- data.frame(table(s$Depth))
        f <- cbind(info, db)
        colnames(f) <- c("Transmitter.Name","Date","Sex","Season", "Species", "Depth", 
                        "No_Det")
        det_data <- rbind(det_data,f)
    }
}

det_data <- det_data[-c(1),]
det_data <- merge(det_data, att_det, by.x = "Transmitter.Name", 
by.y = "Transmitter.Name")
write.csv(det_data,"../Data/detection_perday.csv", row.names = FALSE)



# calculate detections per day per 25m depth band - day time only
nin_d <- subset(nin_det, daynight == "day")
det_data25_d <- data.frame(rbind(c(as.character(1:5),6,7)))
colnames(det_data25_d) <- c("Transmitter.Name","Date","Sex","Season","Species",
"Depth_band25", 
                        "No_Det")
det_data25_d$No_Det <- as.numeric(det_data25_d$No_Det)


for(x in unique(nin_d$TagCode)){
    n <- subset(nin_d, TagCode == x)
    for(i in unique(n$Date.local)){
        s <- subset(n, Date.local == i)
        info <- data.frame(x,i,s$Sex[1],s$Seasons[1], s$Species[1])
        s$Depth_bin25 <- as.factor(25*round((s$Depth+12)/25))
        db25 <- data.frame(table(s$Depth_bin25))
        f <- cbind(info, db25)
        colnames(f) <- c("Transmitter.Name","Date","Sex","Season", "Species", 
        "Depth_band25", 
                        "No_Det")
        det_data25_d <- rbind(det_data25_d,f)
    }
}

det_data25_d <- det_data25_d[-c(1),]
det_data25_d <- merge(det_data25_d, att_det, by.x = "Transmitter.Name",
 by.y = "Transmitter.Name")
det_data25_d$daynight <- rep("day",length(det_data25_d$Date))

# calculate proportion of detections at each depth
codes <- c()
Depth_band <- c()
Det_total <- c()
total <- c()
for(x in unique(det_data25_d$Transmitter.Name)){
    a <- subset(det_data25_d, Transmitter.Name == x)
    tot <- sum(a$No_Det)
    for(i in unique(a$Depth_band25)){
        b <- subset(a, Depth_band25 == i)
        d <- sum(b$No_Det)
        codes <- append(codes, x)
        Depth_band <- append(Depth_band, i)
        Det_total <- append(Det_total, d)
        total <- append(total, tot)
    }
}

# join into single dataframe
prop_d <- data.frame(cbind(codes, Depth_band, Det_total, total))
colnames(prop_d) <- c("Transmitter.Name", "Depth_band25", "Det_perDepth", 
"Det_total")
prop_d$Daynight <- rep("day", length(prop_d$Transmitter.Name))
prop_d$Det_perDepth <- as.numeric(as.character(prop_d$Det_perDepth))
prop_d$Det_total <- as.numeric(as.character(prop_d$Det_total))
prop_d$Det_prop <- prop_d$Det_perDepth/prop_d$Det_total


# calculate detections per day per 25m depth band - night time only
nin_n <- subset(nin_det, daynight == "night")
det_data25_n <- data.frame(rbind(c(as.character(1:5),6,7)))
colnames(det_data25_n) <- c("Transmitter.Name","Date","Sex","Season",
"Species","Depth_band25", 
                        "No_Det")
det_data25_n$No_Det <- as.numeric(det_data25_n$No_Det)


for(x in unique(nin_n$TagCode)){
    n <- subset(nin_n, TagCode == x)
    for(i in unique(n$Date.local)){
        s <- subset(n, Date.local == i)
        info <- data.frame(x,i,s$Sex[1],s$Seasons[1], s$Species[1])
        s$Depth_bin25 <- as.factor(25*round((s$Depth+12)/25))
        db25 <- data.frame(table(s$Depth_bin25))
        f <- cbind(info, db25)
        colnames(f) <- c("Transmitter.Name","Date","Sex","Season", "Species", 
        "Depth_band25", 
                        "No_Det")
        det_data25_n <- rbind(det_data25_n,f)
    }
}

det_data25_n <- det_data25_n[-c(1),]
det_data25_n <- merge(det_data25_n, att_det, by.x = "Transmitter.Name", 
by.y = "Transmitter.Name")
det_data25_n$daynight <- rep("night", length(det_data25_n$Date))

det_data25_daynight <- rbind(det_data25_d,det_data25_n)

write.csv(det_data25_daynight,"../Data/detection_daynight.csv", row.names = FALSE)

# calculate proportion of detections at each depth
codes <- c()
Depth_band <- c()
Det_total <- c()
total <- c()
for(x in unique(det_data25_n$Transmitter.Name)){
    a <- subset(det_data25_n, Transmitter.Name == x)
    tot <- sum(a$No_Det)
    for(i in unique(a$Depth_band25)){
        b <- subset(a, Depth_band25 == i)
        d <- sum(b$No_Det)
        codes <- append(codes, x)
        Depth_band <- append(Depth_band, i)
        Det_total <- append(Det_total, d)
        total <- append(total, tot)
    }
}

# join into single dataframe
prop_n <- data.frame(cbind(codes, Depth_band, Det_total, total))
colnames(prop_n) <- c("Transmitter.Name", "Depth_band25", "Det_perDepth", 
"Det_total")
prop_n$Daynight <- rep("night", length(prop_n$Transmitter.Name))
prop_n$Det_perDepth <- as.numeric(as.character(prop_n$Det_perDepth))
prop_n$Det_total <- as.numeric(as.character(prop_n$Det_total))
prop_n$Det_prop <- prop_n$Det_perDepth/prop_n$Det_total

prop_daynight <- rbind(prop_d, prop_n)
prop_daynight <- left_join(prop_daynight, att_prop, by = "Transmitter.Name")
write.csv(prop_daynight,"../Data/detprop_daynight.csv", row.names = FALSE)


##### CALCULATE MOVEMENTS PER INDIVIDUAL PER DAY WITHIN NINGALOO #####

# mov_data <- data.frame(rbind(c(as.character(1:5),6)))
# colnames(mov_data) <- c("Transmitter.Name","Date","Sex","Season","Species","No_Movs")
# mov_data$No_Movs <- as.numeric(mov_data$No_Movs)
# nin_mov <- nin[!is.na(nin$Movement),]



# for(x in unique(nin_mov$TagCode)){
#     n <- subset(nin_mov, TagCode == x)
#     for(i in unique(n$Date.local)){
#         s <- subset(n, Date.local == i)
#         info <- data.frame(x,i,s$Sex[1],s$Seasons[1], s$Species[1],length(s$Movement))
#         colnames(info) <- c("Transmitter.Name","Date","Sex","Season", "Species","No_Movs")
#         mov_data <- rbind(mov_data,info)
#     }
# }

# mov_data <- mov_data[-c(1),]
# att_mov <- att %>% dplyr::select(Transmitter.Name, Migratory.Status)
# mov_data <- merge(mov_data, att_mov, by.x = "Transmitter.Name", by.y = "Transmitter.Name")
# write.csv(mov_data,"../Data/movements_perday.csv", row.names = FALSE)
