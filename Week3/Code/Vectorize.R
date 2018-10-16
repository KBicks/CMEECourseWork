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

 print(system.time(SumAllElements(M))) 
 print(system.time(sum(M))) 