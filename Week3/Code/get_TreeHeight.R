InputData <- read.csv(z), header=TRUE)

for (i in InputData) {
    radians <- InputData$Angle.degrees * pi /180
    height <- InputData$Distance.m * tan(radians)
    Height.m <- c(height)
}
TreeHeight <- data.frame(Trees, Height.m)
write.csv(TreeHeight,"../Results/TreeHts.csv")
