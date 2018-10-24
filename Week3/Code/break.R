# if and else statements and stopping the code at a certain parameter

i <- 0 #initialize i
    while(i<Inf) {
        # once i reaches 20, break
        if (i==20) {
            break } 
        else {
            # if not 20, print
            cat("i equals " , i, "\n")
            i <- i+1 
        
        }
    }