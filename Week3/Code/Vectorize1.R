M <- matrix(runif(100000),1000,1000) #generate a 1000x1000 matrix of random numbers up to 1million

SumAllElements <- function(M) {
    Dimensions <- dim(M) #sets matrix dimensions
    Tot <- 0 
    for (i in 1:Dimensions[1]){ #for every row in matrix
        for (j in 1:Dimensions[2]){ #for every column in matrix
            Tot <- Tot + M[i,j] #add each element
        }
    }
    return (Tot) #give overall total
 }

 # comparison of the time taken using SumAllElements() and sum()
 # longer method as runs a for loop
 print(system.time(SumAllElements(M)))
 # quicker as draws on a program written C which is more primitive and faster to run
 print(system.time(sum(M)))