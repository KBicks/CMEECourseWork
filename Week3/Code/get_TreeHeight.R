Input = commandArgs(trailingOnly = TRUE)

Trees <- read.csv(Input, header=TRUE)

for (i in Trees) {
    radians <- Trees$Angle.degrees * pi /180
    height <- Trees$Distance.m * tan(radians)
    Height.m <- c(height)
}

TreeHeight <- data.frame(Trees, Height.m)
Output <- unlist(strsplit(Input, split="/", fixed=TRUE))[-1][-1]
Output<- gsub(".csv", "", Output)


write.csv(TreeHeight,file = paste0("../Results/",Output,"_treeheights.csv"))
