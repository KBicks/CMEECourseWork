# Clear workspace
rm(list=ls())

# Set working directory
setwd("~/Documents/CMEECourseWork/Week4/Code")

d <- read.table("../Data/SparrowSize.txt", header=TRUE)
str(d)

# Show fields
names(d)

# Print first rows of data
head(d)

# Check number of variables
length(d$Tarsus)

# Plot a histogram of variables
hist(d$Tarsus)

# Distribution of data
mean(d$Tarsus)
help(mean)
# Remove NA values
mean(d$Tarsus, na.rm=TRUE)
median(d$Tarsus, na.rm=TRUE)
# Not applicable for numerical data
mode(d$Tarsus)

# Create multiple panels
par(mfrow = c(2,2))
hist(d$Tarsus, breaks = 3,col="grey")
hist(d$Tarsus, breaks = 10,col="grey")
hist(d$Tarsus, breaks = 30,col="grey")
hist(d$Tarsus, breaks = 100,col="grey")

install.packages("modeest")
require(modeest)
?modeest
# Creates subset without NA rows
d2 <- subset(d, d$Tarsus!="NA")
length(d$Tarsus)
length(d2$Tarsus)
mlv(d2$Tarsus)
# errors occur but apparently that's ok - data are not continuous

#Range, variance and standard deviation
range(d$Tarsus, na.rm=TRUE)
range(d2$Tarsus, na.rm=TRUE)
var(d$Tarsus, na.rm=TRUE)
var(d2$Tarsus, na.rm=TRUE)
# breaking down sum of squares 
sum((d2$Tarsus - mean(d2$Tarsus))^2)/(length(d2$Tarsus)-1)
sqrt(var(d2$Tarsus))
sqrt(0.74)
sd(d2$Tarsus)

# Z scores - normalizing data
# z = (y - mean(y))/sd(y)

zTarsus <- (d2$Tarsus - mean(d2$Tarsus))/sd(d2$Tarsus)
var(zTarsus) #is 1 for standardized data
sd(zTarsus) # is 1 for standardized data
hist(zTarsus)

# Making data sets
set.seed(123)
znormal <- rnorm(1e+06)
hist(znormal, breaks = 100)
summary(znormal)
# values of 95% confidence interval
qnorm(c(0.025,0.975))
pnorm(.Last.value) #corresponding probabilities

par(mfrow = c(1,2))
hist(znormal, breaks = 100)
#plotting quartile divisions
abline(v = qnorm(c(0.25,0.5,0.75)),lwd = 2)
abline(v= qnorm(c(0.025,0.975)),lwd = 2, lty="dashed")
plot(density(znormal))
abline(v = qnorm(c(0.25, 0.5, 0.75)), col = "gray") 	
abline(v = qnorm(c(0.025, 0.975)), lty = "dotted", col = "black") 	
abline(h = 0, lwd = 3, col = "blue")
# adds text to axes
text(2, 0.3, "1.96", col = "red", adj = 0) 	
text(-2, 0.3, "-1.96", col = "red", adj = 1) 	
#using Sex.1 gives values from header for y label as opposed to 1 and 0
boxplot(d$Tarsus~d$Sex.1,col=c("red","blue"),ylab="Tarsus length (mm)")

