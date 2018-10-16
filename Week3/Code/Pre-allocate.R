# two methods for allocating values to a vector
a <- 1
for (i in 1:10){
    a[i] = 10
}

a <- rep(NA,10) #creates vector of NAs, length 10 - populates as function runs

for (i in 1:10){
    a[i] = 10
}