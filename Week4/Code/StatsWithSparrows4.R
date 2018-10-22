# Standard errors

rm(list=ls())
setwd("~/Documents/CMEECourseWork/Week4/Code")

d <- read.table("../Data/SparrowSize.txt", header=TRUE)
#subset to remove NA values from Tarsus length
d1<-subset(d,d$Tarsus!="NA")
seTarsus<-sqrt(var(d1$Tarsus)/length(d1$Tarsus))
seTarsus

d1_2001<-subset(d1,d1$Year==2001)
seTarsus_2001<-sqrt(var(d1_2001$Tarsus)/length(d1_2001$Tarsus))
seTarsus_2001
#increasing sample size reduces standard error

##Exercises
##Standard Errors:
#Tarsus
dTarsus<-subset(d,d$Tarsus!="NA")
seTarsus<-sqrt(var(dTarsus$Tarsus)/length(dTarsus$Tarsus))
length(dTarsus$Tarsus)
print(seTarsus)
#Mass
dMass<-subset(d,d$Mass!="NA")
seMass<-sqrt(var(dMass$Mass)/length(dMass$Mass))
length(dMass$Mass)
print(seMass)
#Wing Length
dWing<-subset(d,d$Wing!="NA")
seWing<-sqrt(var(dWing$Wing)/length(dWing$Wing))
length(dWing$Wing)
print(seWing)
#Bill Length
dBill<-subset(d,d$Bill!="NA")
seBill<-sqrt(var(dBill$Bill)/length(dBill$Bill))
length(dBill$Bill)
print(seBill)

##For 2001 only
#Subsetting to 2001 data only
d2001<-subset(d,d$Year==2001)

#Tarsus
d2001Tarsus<-subset(d2001,d2001$Tarsus!="NA")
se2001Tarsus<-sqrt(var(d2001Tarsus$Tarsus)/length(d2001Tarsus$Tarsus))
length(d2001Tarsus$Tarsus)
print(se2001Tarsus)
#Mass
d2001Mass<-subset(d2001,d2001$Mass!="NA")
se2001Mass<-sqrt(var(d2001Mass$Mass)/length(d2001Mass$Mass))
length(d2001Mass$Mass)
print(se2001Mass)
#Wing Length
d2001Wing<-subset(d2001,d2001$Wing!="NA")
se2001Wing<-sqrt(var(d2001Wing$Wing)/length(d2001Wing$Wing))
length(d2001Wing$Wing)
print(se2001Wing)
#Bill Length
d2001Bill<-subset(d2001,d2001$Bill!="NA")
se2001Bill<-sqrt(var(d2001Bill$Bill)/length(d2001Bill$Bill))
length(d2001Bill$Bill)
print(se2001Bill)

# 95% CI of each variable