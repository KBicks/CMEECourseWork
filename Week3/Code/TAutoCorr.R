rm(list=ls())
load("../Data/KeyWestAnnualMeanTemperature.RData")
# str(ats)
# plot(ats)

temps1<-ats[1:98,2]
temps2<-ats[2:99,2]

a = cor(temps1, temps2)

temp <- function(x,y) {
    s1<-sample(x,length(x))
    s2<-sample(y,length(y))
    cor(s1,s2)
}

results <- lapply(1:10000,function(i) temp(temps1,temps2))

length(results[results>a])/length(results)