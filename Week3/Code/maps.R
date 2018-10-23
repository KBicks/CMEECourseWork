require(maps)

load("../Data/GPDDFiltered.RData")

map("world")
points(gpdd$long,gpdd$lat,pch=7, col="green")