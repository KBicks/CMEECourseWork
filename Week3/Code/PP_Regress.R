
rm(list=ls())

require(ggplot2)
require(plyr)
require(dplyr)


PredPrey <- read.csv("../Data/EcolArchives-E089-51-D1.csv", header=T)
dplyr::glimpse(PredPrey)
dplyr::tbl_df(PredPrey)

InterPlot <- qplot(
    Prey.mass, Predator.mass,
    facets = Type.of.feeding.interaction ~.,
    data = PredPrey,
    log = "xy",
    colour = Predator.lifestage,
    xlab = "Prey Mass in grams",
    ylab = "Predator Mass in grams")

Finalplot <- InterPlot + geom_smooth(method = "lm", fullrange = T) + geom_point(shape = 9) +
     theme_bw() + theme(legend.position="bottom")

pdf("../Results/PP_Regress.pdf", 11.7, 8.3)
print(Finalplot)
graphics.off()

model.grouped <- dlply(PredPrey, .(Type.of.feeding.interaction,Predator.lifestage), function(PredPrey) lm(log(Predator.mass)~log(Prey.mass), data=PredPrey))

model.sum <- ldply(model.grouped, function(PredPrey){
    intercept <- summary(PredPrey)$coefficients[1]
    slope <- summary(PredPrey)$coefficients[2]
    p.value <- summary(PredPrey)$coefficients[8]
    R2 <- summary(PredPrey)$r.squared
    data.frame(slope,intercept,R2,p.value)
})

F.statistic <- ldply(model.grouped, function(PredPrey) summary(PredPrey)$fstatistic[1])
model.sum <- merge(model.sum, F.stat, by = c("Type.of.feeding.interaction","Predator.lifestage"),all=T)

names(model.sum)[3] <- "Regression.slope"
names(model.sum)[4] <- "Regression.intercept"
names(model.sum)[7] <- "F-Statistic"
names(model.sum)[6] <- "P-Value"

write.csv(model.sum,"../Results/PP_Regress_Results.csv", row.names=F, quote=F)