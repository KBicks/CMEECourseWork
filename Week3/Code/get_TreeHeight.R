Input = commandArgs(trailingOnly = TRUE)

for (i in Input) {
    radians <- Input$Angle.degrees * pi /180
    height <- Input$Distance.m * tan(radians)
    Height.m <- c(height)
}


TreeHeight <- data.frame(Trees, Height.m)
write.csv(TreeHeight,"../Results/TreeHts.csv")
