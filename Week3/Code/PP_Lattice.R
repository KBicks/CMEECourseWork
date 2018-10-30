
rm(list=ls())

require(lattice)
require(dplyr)
require(ggplot2)

PredPrey <- read.csv("../Data/EcolArchives-E089-51-D1.csv", header=T)
dplyr::tbl_df(PredPrey)
dplyr::glimpse(PredPrey)

pdf("../Results/Prey_Lattice.pdf", 11.7,8.3)
qplot(log(Prey.mass), facets = Type.of.feeding.interaction ~., 
    data = PredPrey, geom = "density", xlab="Prey Mass (kg)")
dev.off()

pdf("../Results/Pred_Lattice.pdf", 11.7,8.3)
qplot(log(Predator.mass), facets = Type.of.feeding.interaction ~., 
    data = PredPrey, geom = "density", xlab="Predator Mass (kg)")
dev.off()

pdf("../Results/SizeRatio_Lattice.pdf",11.7,8.3)
qplot(log(Predator.mass/Prey.mass), facets = Type.of.feeding.interaction ~., 
    data = PredPrey, geom = "density", xlab="Ratio of Predator to Prey Mass")
dev.off()

Prey <- PredPrey %>% group_by(Type.of.feeding.interaction) %>% summarise(
    Mean= mean(log(Prey.mass)), Median = median(log(Prey.mass))
)
Prey$"Type" <- "Log.Prey.Mass"

Pred <- PredPrey %>% group_by(Type.of.feeding.interaction) %>% summarise(
    Mean= mean(log(Predator.mass)), Median = median(log(Predator.mass))
)
Pred$"Type" <- "Log.Predator.Mass)"

PredPreyRatio <- PredPrey %>% group_by(Type.of.feeding.interaction) %>% summarise(
    Mean= mean(log(Predator.mass/Prey.mass)), Median = median(log(Predator.mass/Prey.mass))
)
PredPreyRatio$"Type" <- "Log.predator.prey.size.ratio"

SummaryStats <- rbind(Pred,Prey,PredPreyRatio)
write.csv(SummaryStats, "../Results/PP_Results.csv", row.names=F )