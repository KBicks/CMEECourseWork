# iterates a function for correlation between temperatures over successive
# years

rm(list=ls())
load("../Data/KeyWestAnnualMeanTemperature.RData")
# str(ats)
# plot(ats)

# two subsets of the data
temps1<-ats[1:98,2]
temps2<-ats[2:99,2]

# calculate correlation of original data
a = cor(temps1, temps2)

# randomly selects values in the dataset and calculates correlation
temp <- function(x,y) {
    s1<-sample(x,length(x))
    s2<-sample(y,length(y))
    cor(s1,s2)
}

# run the function temp, 10000 times 
results <- lapply(1:10000,function(i) temp(temps1,temps2))

# calculate and print the p value, based on the 10000 iterations
print("The approximate p-value is" )
print(length(results[results>a])/length(results))