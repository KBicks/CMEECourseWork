# Set working directory
getwd()
setwd("~/Documents/CMEECourseWork/Week4/Code")
getwd()

# Basic commands
2*2+1
2*(2+1)
12/2^3
(12/2)^3

# Assign values to variables
x<-5
x
y<-2
y
x2<-x^2
x2
a<-x^2+x
a
y2<-y^2
z2<-x2+y2
z <-sqrt(z2)
print(z)

# Logic tests
3>2
3>=3
4<2

# Making vectors
myNumericVector<- c(1.3,2.5,1.9,3.4,5.6,1.4,3.1,2.9)
myCharacterVector<- c("low","low","low","low","high","high","high","high")
myLogicalVector<- c(TRUE,TRUE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE)
# get structure of variable:
str(vector)
myMixedVector<- c(1,TRUE,FALSE,3,"help",1.2,TRUE,"notwhatIplanned")

# Installing packages
install.packages("lme4")
library(lme4)
# require is better than using library
require(lme4)
help(lme4)
help(log)

# Special Notations
sqrt(4)
4^0.5
log(0)
log(1)
log(10)
log(Inf)
exp(1)
pi

# Clear workspace
rm(list=ls())

# Entering data
d <- read.table("../Data/SparrowSize.txt", header=TRUE)
str(d)