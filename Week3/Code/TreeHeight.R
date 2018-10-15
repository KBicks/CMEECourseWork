# Script to calculate tree height from distance to base and angle to top

# height = distance * tan(radians)

# Arguments
# degrees: The angle of elevation of tree
# distance: The distance from base of tree (meters)

# Output
# The heights of the tree, same units as distance

Trees <- read.csv("../Data/trees.csv", header=TRUE)

for (i in Trees) {
    radians <- Trees$Angle.degrees * pi /180
    height <- Trees$Distance.m * tan(radians)
    Height.m <- c(height)
}
TreeHeight <- data.frame(Trees, Height.m)
write.csv(TreeHeight,"../Results/TreeHts.csv")