# two methods for allocating values to a vector
# both create a vector of NAs, length 100000 - which populates as function runs

# initial value of a set as NA - generates one value at a time
a <- NA
NotPreallocated <- function(a){
    for (i in 1:100000){
        a <- c(a,i)
    }
}

# starts with dimensions of a given and structure already created, then replaces each NA
# quicker option
a <- rep(NA,10000) 
Preallocated <- function(a){
    for (i in 1:100000){
        a[i] <- i
    }
}

# check times taken by both options
print(system.time(NotPreallocated(a)))
print(system.time(Preallocated(a)))