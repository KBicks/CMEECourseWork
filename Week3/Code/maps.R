# create a world map with data points from the specified data set
# require library
require(maps)

load("../Data/GPDDFiltered.RData")

# produce map of world
map("world")
points(gpdd$long,gpdd$lat,pch=7, col="green")

# The distribution of the data is localised to several specific areas indicating
# biased location of data collection, and is unlikely to be suitable to be 
# examined on a global scale.