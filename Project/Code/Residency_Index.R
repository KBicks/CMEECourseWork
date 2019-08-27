#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: Residency_Index.R
# Desc: Calculating residency index over
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
nin$Season <- c(summer1,autumn,winter,spring,summer2)

# add sunset and sunrise times to each detection
nin <- inner_join(nin, ss)
# classify each detection as day or night
nin$daynight <- ifelse(hms(nin$Time.local) > hms(nin$Sunrise) & 
                  hms(nin$Time.local) < hms(nin$Sunset), 'day', 'night')

# remove columns used for calculation only
nin <- nin %>% dplyr::select(-Sunrise, -Sunset)
colnames(nin)[1] <- "Transmitter.Name"



### CALCULATE RESIDENCY INDEX


codes <- c()
days <- c()
# number of days detected
for(x in unique(nin$Transmitter.Name)){
    a <- subset(nin, Transmitter.Name == x)
    n <- length(unique(a$Date.local))
    codes <- append(codes, x)
    days <- append(days, n)
}

# bind dataframe of number of days detected
res <- data.frame(cbind(codes,days))
colnames(res) <- c("Transmitter.Name","Days_det")
# select columns of attributes file required
att_res <- att %>% dplyr::select(Transmitter.Name, ReleaseDate)
res <- left_join(res, att_res, by = "Transmitter.Name")
res$Days_det <- as.numeric(as.character(res$Days_det))

codes <- c()
last <- c()
# calculate last detection
for(x in unique(res$Transmitter.Name)){
    n <- subset(nin, Transmitter.Name == x)
    a <- max(as.Date(n$Date.local))
    codes <- append(codes, x)
    last <- append(last, as.Date(a))
}

last <- data.frame(cbind(codes, as.character(last)))
colnames(last) <- c("Transmitter.Name", "Last_Detection")
res <- left_join(res, last, by = "Transmitter.Name")

# calculate time monitored
res$Duration_days <- as.Date(res$Last_Detection)+1 - as.Date(res$ReleaseDate)
# calculate overall residency index 
res$Duration_days <- as.numeric(as.character(res$Duration_days))
res$Total_RI <- res$Days_det / res$Duration_days
res$ReleaseDate <- as.Date(res$ReleaseDate)
res$Last_Detection <- as.Date(res$Last_Detection)
res$Last_month <- month(res$Last_Detection)
res$Last_year <- year(res$Last_Detection)
res$Release_month <- month(res$ReleaseDate)
res$Release_year <- year(res$ReleaseDate)
res$Duration_years <- res$Last_year - res$Release_year





### CALCULATING RESIDENCY INDEX PER SEASON


codes_au <- c()
codes_wi <- c()
au <- c()
wi <- c()
for(x in unique(res$Transmitter.Name)){
    r <- subset(res, Transmitter.Name == x)
    if(r$Release_month > 2 & r$Release_month < 6){
        d <- paste0(r$Release_year,"-06-01")
        c <- as.numeric(as.character(as.Date(d) - r$ReleaseDate))
        au <- append(au, c)
        codes_au <- append(codes_au, x)
    }
    if(r$Release_month > 5 & r$Release_month < 9){
        d <- paste0(r$Release_year,"-09-01")
        c <- as.numeric(as.character(as.Date(d) - r$ReleaseDate))
        wi <- append(wi, c)
        codes_wi <- append(codes_wi, x)
    }
}

start_a <- data.frame(cbind(codes_au, au, rep(92,length(au)),
rep(91,length(au)),rep(31,length(au))))
colnames(start_a) <- c("Transmitter.Name","Autumnst","Winterst",
"Springst","Summerst")
start_w <- data.frame(cbind(codes_wi, wi,rep(91,length(wi)), 
rep(31,length(wi))))
colnames(start_w) <- c("Transmitter.Name","Winterst",
"Springst","Summerst")

m <- full_join(start_a,start_w)


mid <- subset(res, Duration_years > 1)
mid <- mid %>% dplyr::select(Transmitter.Name, Duration_years)
mid$au_mid <- 92*(mid$Duration_years - 1)
mid$wi_mid <- 92*(mid$Duration_years - 1)
mid$sp_mid <- 91*(mid$Duration_years - 1)
mid$su_mid <- 90*(mid$Duration_years - 1)
mid <- mid %>% dplyr::select(-Duration_years)

m <- left_join(m, mid, by = "Transmitter.Name")



codes_a <- c()
codes_w <- c()
codes_sp <- c()
codes_su1 <- c()
codes_su2 <- c()
a <- c()
w <- c()
sp <- c()
su_1 <- c()
su_2 <- c()

for(x in unique(res$Transmitter.Name)){
    r <- subset(res, Transmitter.Name == x)
    if(r$Last_month < 3){
        d <- paste0(r$Last_year-1,"-12-31")
        c <- as.numeric(as.character(r$Last_Detection - as.Date(d)))
        su_1 <- append(su_1, c)
        codes_su1 <- append(codes_su1, x)
    }
    if(r$Last_month > 2 & r$Last_month < 6){
        d <- paste0(r$Last_year,"-02-28")
        c <- as.numeric(as.character(r$Last_Detection - as.Date(d)))
        a <- append(a, c)
        codes_a <- append(codes_a, x)
    }
    if(r$Last_month > 5 & r$Last_month < 9){
        d <- paste0(r$Last_year,"-04-30")
        c <- as.numeric(as.character(r$Last_Detection - as.Date(d)))
        w <- append(w, c)
        codes_w <- append(codes_w, x)
    }
    if(r$Last_month > 8 & r$Last_month < 12){
        d <- paste0(r$Last_year,"-08-31")
        c <- as.numeric(as.character(r$Last_Detection - as.Date(d)))
        sp <- append(sp, c)
        codes_sp <- append(codes_sp, x)
    }
    if(r$Last_month > 11){
        d <- paste0(r$Last_year,"-11-30")
        c <- as.numeric(as.character(r$Last_Detection - as.Date(d)))
        su_2 <- append(su_2, c)
        codes_su2 <- append(codes_su2, x)
    }
}

end_su1 <- data.frame(cbind(codes_su1, su_1))
colnames(end_su1) <- c("Transmitter.Name","summer1_end")
end_a <- data.frame(cbind(codes_a, a, rep(59,length(a))))
colnames(end_a) <- c("Transmitter.Name","autumn_end","summer1_end")
end_w <- data.frame(cbind(codes_w, w, rep(59,length(w)),rep(92,length(w))))
colnames(end_w) <- c("Transmitter.Name","winter_end","summer1_end","autumn_end")
end_sp <- data.frame(cbind(codes_sp, sp, rep(59,length(sp)),rep(92,length(sp)),
rep(92,length(sp))))
colnames(end_sp) <- c("Transmitter.Name","spring_end","summer1_end",
"autumn_end","winter_end")
end_su2 <- data.frame(cbind(codes_su2, su_2, rep(59,length(su_2)),
rep(92,length(su_2)),rep(92, length(su_2)), rep(91,length(su_2))))
colnames(end_su2) <- c("Transmitter.Name","summer2_end","summer1_end",
"autumn_end", "winter_end","spring_end")

n <- full_join(end_su2,end_su1)
n <- full_join(n, end_a)
n <- full_join(n, end_w)
n <- full_join(n, end_sp)
days <- left_join(m,n, by = "Transmitter.Name")
days$Winterst <- as.character(days$Winterst)
days$Summerst <- as.character(days$Summerst)
days$Springst <- as.character(days$Springst)
days$Autumnst <- as.character(days$Autumnst)
days$summer2_end <- as.character(days$summer2_end)

# account for leap year days in 2012 and 2016
# all releases April to August so don't need to adjust start for leap years
# add extra summer day for each

codes_end12 <- res$Transmitter.Name[res$Last_year == 2012 & 
res$Last_Detection > as.Date("2012-02-29") & res$ReleaseDate < as.Date("2012-03-01")]
codes_end16 <- res$Transmitter.Name[res$Last_year == 2016 & 
res$Last_Detection > as.Date("2016-02-29") & res$ReleaseDate < as.Date("2016-03-01")]
codes_mid12 <- res$Transmitter.Name[res$Last_year > 2012 & 
res$Release_year < 2012]
codes_mid16 <- res$Transmitter.Name[res$Last_year > 2016 & 
res$Release_year < 2016]
leap <- data.frame(table(c(codes_end12, codes_end16, codes_mid12, codes_mid16)))
colnames(leap) <- c("Transmitter.Name", "summer_extra")

# add leap days to main dataframe
days <- left_join(days, leap, by = "Transmitter.Name")
days <- replace(days,is.na(days),0)

# find totals for each season
days$Summer_days <- as.numeric(as.character(days$Summerst)) + 
as.numeric(as.character(days$su_mid)) + as.numeric(as.character(days$summer2_end)) + 
                as.numeric(as.character(days$summer1_end)) + 
                as.numeric(as.character(days$summer_extra))

days$Spring_days <- as.numeric(as.character(days$Springst)) + 
as.numeric(as.character(days$sp_mid)) + as.numeric(as.character(days$spring_end))
days$Winter_days <- as.numeric(as.character(days$Winterst)) + 
as.numeric(as.character(days$wi_mid)) + as.numeric(as.character(days$winter_end))
days$Autumn_days <- as.numeric(as.character(days$Autumnst)) + 
as.numeric(as.character(days$au_mid)) + as.numeric(as.character(days$autumn_end))
res <- left_join(res, days, by = "Transmitter.Name")

# account for individuals only detected in one year
for(i in 1:length(res$Transmitter.Name)){
    if(res$Release_year[i] == res$Last_year[i]){
        res$Summer_days[i] <- res$Summer_days[i] - 90
        res$Spring_days[i] <- res$Spring_days[i] - 91
        res$Autumn_days[i] <- res$Autumn_days[i] - 92
        res$Winter_days[i] <- res$Winter_days[i] - 92
    } else{}
}



se <- c()
codes <- c()
dur <- c()
for(i in unique(nin$Season)){
    l <- subset(nin, Season == i)
    for(x in unique(l$Transmitter.Name)){
        a <- subset(l, Transmitter.Name == x)
        n <- length(unique(a$Date.local))
        se <- append(se, i)
        codes <- append(codes, x)
        dur <- append(dur, n)

    }
}

dur_se <- data.frame(cbind(codes,se,dur))
dur_se <- tidyr::spread(dur_se, se, dur)
colnames(dur_se) <- c("Transmitter.Name","Autumn_det", "Spring_det", 
"Summer_det", "Winter_det")
res <- left_join(res, dur_se, by = "Transmitter.Name")

# set factors as numeric
res$Autumn_det <- as.numeric(as.character(res$Autumn_det))
res$Winter_det <- as.numeric(as.character(res$Winter_det))
res$Spring_det <- as.numeric(as.character(res$Spring_det))
res$Summer_det <- as.numeric(as.character(res$Summer_det))

res$check <- res$Duration_days - (res$Summer_days + res$Autumn_days + 
res$Spring_days + res$Winter_days)

# account for individuals where winter dates have been duplicated
for(i in 1:length(res$Transmitter.Name)){
    if(res$check[i] == -31 | res$check[i] == -32){
        res$Winter_days[i] <- res$Winter_days[i] - 31
    } 
    if(res$check[i] == -1){
        res$Autumn_days[i] <- res$Autumn_days[i] - 1
    } else{}
}

# calculate seasonal residency indexes
res$SummerRI <- res$Summer_det/res$Summer_days
res$SpringRI <- res$Spring_det/res$Spring_days
res$WinterRI <- res$Winter_det/res$Winter_days
res$AutumnRI <- res$Autumn_det/res$Autumn_days

ind <- res %>% dplyr::select(Transmitter.Name, Last_Detection, 
Duration_days, Summer_days, Autumn_days,
                            Winter_days, Spring_days, Days_det, Summer_det, 
                            Autumn_det, Winter_det, Spring_det,
                            Total_RI, SummerRI, AutumnRI, WinterRI, SpringRI)

ind <- left_join(att, ind, by = "Transmitter.Name")


### CALCULATE RESIDENCY INDEX FOR TIME OF DAY

codes <- c()
det_day <- c()
det_night <- c()
for(x in unique(ind$Transmitter.Name)){
    f <- subset(nin, Transmitter.Name == x)
    codes <- append(codes, x)
    d <- length(unique(f$Date.local[f$daynight == "day"]))
    det_day <- append(det_day, d)
    n <- length(unique(f$Date.local[f$daynight == "night"]))
    det_night <- append(det_night, n)
}

timings <- data.frame(cbind(codes, det_day, det_night))
colnames(timings) <- c("Transmitter.Name", "Daytime_det", "Night_det")

ind <- left_join(ind, timings, by = "Transmitter.Name")

ind$Daytime_det <- as.numeric(as.character(ind$Daytime_det))
ind$Night_det <- as.numeric(as.character(ind$Night_det))

ind$DayRI <- ind$Daytime_det / ind$Duration_days
ind$NightRI <- ind$Night_det / ind$Duration_days

write.csv(ind, "../Data/shark_attributes.csv", row.names = FALSE)