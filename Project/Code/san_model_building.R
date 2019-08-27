#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: san_model_building.R
# Desc: Building and comparing models for various shark response variables.
# Arguments: None
# Date: 20 May 2019


rm(list=ls())
graphics.off()


# required packages
require(tidyverse)
require(lme4)
require(car)
require(MASS)
require(merTools)
require(MuMIn)




# load datasets
att <- read.csv("../Data/shark_attributes.csv", header = TRUE)
mov <- read.csv("../Data/movements_perday.csv", header = TRUE)
#det10 <- read.csv("../Data/detection_perday10.csv", header = TRUE)
det25 <- read.csv("../Data/detection_perday25.csv", header = TRUE)
#det50 <- read.csv("../Data/detection_perday50.csv", header = TRUE)
detdn <- read.csv("../Data/detection_daynight.csv", header = TRUE)


# function to select most common from a list of factors
factor_mode <- function(x){
    aa <- unique(x)
    aa[which.max(tabulate(match(x,aa)))]
}




colnames(att) <- gsub("day", "Day", colnames(att))
colnames(att) <- gsub("night", "Night", colnames(att))

# subset for seasons
season_names <- c("Spring", "Summer", "Autumn","Winter")
seasons <- data.frame()
for(x in season_names){
    a <- att %>% dplyr::select(Transmitter.Name, Species, Sex, FL, Migratory.Status, 
                    paste0("MCP_area_season_",x), paste0("core_KUD_season_",x), 
                    paste0("Network_Density_", x), paste0(x,"RI"))
    colnames(a)[6:9] <- c("MCP_area","core_KUD","Network_Density","RI")
    a$Season <- rep(x, length(a$Transmitter.Name))
    seasons <- rbind(seasons, a)
}

# subset for time of day
day_times <- c("Day", "Night")
daynight <- data.frame()
for(x in day_times){
    a <- att %>% dplyr::select(Transmitter.Name, Species, Sex, FL, Migratory.Status, 
                    paste0("MCP_area_",x), paste0("core_KUD_",x), 
                    paste0("Network_Density_", x), paste0(x,"RI"))
    colnames(a)[6:9] <- c("MCP_area","core_KUD","Network_Density","RI")
    a$Daynight <- rep(x, length(a$Transmitter.Name))
    daynight <- rbind(daynight, a)
}


# subset for season x time of day for network analysis
time_names <- c("Day_Spring", "Day_Summer", "Day_Autumn",
"Day_Winter", "Night_Spring", 
"Night_Summer", "Night_Autumn","Night_Winter")
times <- data.frame()
for(x in time_names){
    a <- att %>% dplyr::select(Transmitter.Name, Species, Sex, FL, Migratory.Status, 
                    paste0("Network_Density_", x))
    colnames(a)[6] <- "Network_Density"
    a$Time <- rep(x, length(a$Transmitter.Name))
    times <- rbind(times, a)
}

times <- separate(times, Time, c("daynight","Season"), sep = "_")





san_seasons <- seasons[seasons$Species == "Sandbar",]
san_daynight <- daynight[daynight$Species == "Sandbar",]
san_times <- times[times$Species == "Sandbar",]










##### CONVEX POLYGONS MODEL - ALL #####

# ## Season subset

# # removing missing values from dataframe and setting to own variable
# san_MCP_se <- san_seasons
# san_MCP_se <- san_MCP_se[!is.na(san_MCP_se$MCP_area),]
# san_MCP_se$Season <- factor(san_MCP_se$Season, levels = c("Summer","Autumn", "Winter", "Spring"))


# # deciding distribution for model
# par(mfrow = c(2,2))
# # normal distribution
# qqp(san_MCP_se$MCP_area, "norm")
# # log normal distribution
# qqp(san_MCP_se$MCP_area, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(san_MCP_se$MCP_area), "Negative Binomial")
# qqp(san_MCP_se$MCP_area, "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(san_MCP_se$MCP_area), "Poisson")
# qqp(san_MCP_se$MCP_area, "pois", lambda = poisson$estimate)
# # best fit is normal - none are brilliant fits - checked against reduced seasons

# # Linear mixed models

# # null model
# MCP_glmm_null <- lmer(MCP_area ~ 1 + (1|Transmitter.Name), data = san_MCP_se, REML = FALSE)
# # summary(MCP_glmm_null)
# MCP_lm_null <- lm(MCP_area ~1, data = san_MCP_se)
# # anova(MCP_glmm_null, MCP_lm_null)

# # single variable models
# MCP_glmm_sex <- lmer(MCP_area ~ Sex + (1|Transmitter.Name), data = san_MCP_se, REML = FALSE)
# # summary(MCP_glmm_sex)
# # anova(MCP_glmm_null, MCP_glmm_sex)

# MCP_glmm_sea <- lmer(MCP_area ~ Season + (1|Transmitter.Name), data = san_MCP_se, REML = FALSE)
# # summary(MCP_glmm_sea)
# # anova(MCP_glmm_null, MCP_glmm_sea)




# ## Time of day subset

# # removing missing values from dataframe and setting to own variable
# san_MCP_dn <- san_daynight
# san_MCP_dn <- san_MCP_dn[!is.na(san_MCP_dn$MCP_area),]

# # null model
# MCP_glmm_null <- lmer(MCP_area ~ 1 + (1|Transmitter.Name), data = san_MCP_dn, REML = FALSE)
# # summary(MCP_glmm_null)
# MCP_lm_null <- lm(MCP_area ~1, data = san_MCP_dn)
# # anova(MCP_glmm_null, MCP_lm_null)

# # single variable models
# MCP_glmm_sex <- lmer(MCP_area ~ Sex + (1|Transmitter.Name), data = san_MCP_dn, REML = FALSE)
# # summary(MCP_glmm_sex)
# # anova(MCP_glmm_null, MCP_glmm_sex)

# MCP_glmm_dn <- lmer(MCP_area ~ Daynight + (1|Transmitter.Name), data = san_MCP_dn, REML = FALSE)
# # summary(MCP_glmm_dn)
# # anova(MCP_glmm_null, MCP_glmm_dn)


















##### CORE KERNEL DENSITY MODEL - ALL #####

# seasons subsets

san_KUD_se <- san_seasons
san_KUD_se <- san_KUD_se[!is.na(san_KUD_se$core_KUD),]
san_KUD_se$Season <- factor(san_KUD_se$Season, levels = c("Summer","Autumn", 
"Winter", "Spring"))


# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(san_KUD_se$core_KUD, "norm")
# # log normal distribution
# qqp(san_KUD_se$core_KUD, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(san_KUD_se$core_KUD), "Negative Binomial")
# qqp(san_KUD_se$core_KUD, "nbinom", size = nbinom$estimate[[1]], 
#mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(san_KUD_se$core_KUD), "Poisson")
# qqp(san_KUD_se$core_KUD, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(san_KUD_se$core_KUD, "gamma")
# qqp(san_KUD_se$core_KUD, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
# # best fit is gamma - normal distribution also close


# Linear mixed models 

# null model
KUD_glmm_null <- glmer(core_KUD ~ 1 + (1|Transmitter.Name), 
data = san_KUD_se, family = Gamma)
# summary(KUD_glmm_null)
KUD_lm_null <- lm(core_KUD ~ 1, data = san_KUD_se)
# anova(KUD_glmm_null, KUD_lm_null)

# single variable models
KUD_glmm_sx <- glmer(core_KUD ~ Sex + (1|Transmitter.Name), data = san_KUD_se, 
family = Gamma)
# summary(KUD_glmm_sx)
# anova(KUD_glmm_null, KUD_glmm_sx)

KUD_glmm_se <- glmer(core_KUD ~ Season + (1|Transmitter.Name), data = san_KUD_se, 
family = Gamma)
# summary(KUD_glmm_se)
# anova(KUD_glmm_null, KUD_glmm_se)

san_kud_aic_se <- AIC(KUD_glmm_null, KUD_glmm_sx, KUD_glmm_se)

## Time of day subset

# removing missing values from dataframe and setting to own variable
san_KUD_dn <- san_daynight
san_KUD_dn <- san_KUD_dn[!is.na(san_KUD_dn$core_KUD),]


# Linear mixed models 

# null model
KUD_glmm_null <- glmer(core_KUD ~ 1 + (1|Transmitter.Name), data = san_KUD_dn, 
family = Gamma)
# summary(KUD_glmm_null)
KUD_lm_null <- lm(core_KUD ~ 1, data = san_KUD_dn)
# anova(KUD_glmm_null, KUD_lm_null)

# single variable models
KUD_glmm_sx <- glmer(core_KUD ~ Sex + (1|Transmitter.Name), data = san_KUD_dn, 
family = Gamma)
# summary(KUD_glmm_sx)
# anova(KUD_glmm_null, KUD_glmm_sx)

KUD_glmm_dn <- glmer(core_KUD ~ Daynight + (1|Transmitter.Name), data = san_KUD_dn, 
family = Gamma)
# summary(KUD_glmm_dn)
# anova(KUD_glmm_null, KUD_glmm_dn)


san_kud_aic_dn <- AIC(KUD_glmm_null, KUD_glmm_sx, KUD_glmm_dn)

















##### NETWORK DENSITY MODELS - ALL #####



# seasons species subsets
san_net_se <- san_seasons
san_net_se <- san_net_se[!is.na(san_net_se$Network_Density),]
san_net_se$Season <- factor(san_net_se$Season, levels = c("Summer","Autumn", 
"Winter", "Spring"))




## deciding distribution for model
# par(mfrow = c(1,3))
# # normal distribution
# qqp(san_net_se$Network_Density, "norm")
# # log normal distribution
# qqp(san_net_se$Network_Density, "lnorm")
# # gamma
# gamma <- fitdistr(san_net_se$Network_Density, "gamma")
# qqp(san_net_se$Network_Density, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
## best fit is log normal



# Linear mixed models 

# null model
san_net_glmm_null <- glmer(Network_Density ~ 1 + (1|Transmitter.Name), 
data = san_net_se, family = gaussian(link = "log"))
# summary(san_net_glmm_null)
# r.squaredGLMM(san_net_glmm_null)
san_net_lm_null <- lm(log(Network_Density) ~ 1, data = san_net_se)
# anova(san_net_glmm_null, san_net_lm_null)

# single variable models
san_net_glmm_sx <- glmer(Network_Density ~ Sex + (1|Transmitter.Name), 
data = san_net_se, family = gaussian(link = "log"))
# summary(san_net_glmm_sx)
# anova(san_net_glmm_null, san_net_glmm_sx)
# r.squaredGLMM(san_net_glmm_sx)

san_net_glmm_se <- glmer(Network_Density ~ Season + (1|Transmitter.Name), 
data = san_net_se, family = gaussian(link = "log"))
# summary(san_net_glmm_se)
# anova(san_net_glmm_null, san_net_glmm_se)
# r.squaredGLMM(san_net_glmm_se)

san_net_aic_se <- AIC(san_net_glmm_null, san_net_glmm_sx, san_net_glmm_se)


### Model prediction - seasonal variation

# new_san_net <- data.frame(cbind(
#         rep(as.character(factor_mode(san_net_se$Transmitter.Name)),4),
#         c("Summer","Autumn", "Winter", "Spring")))
# colnames(new_san_net) <- c("Transmitter.Name", "Season")

# # predicted model values
# PI <- predictInterval(san_net_glmm_se, newdata = new_san_net, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# pred_san_net <- data.frame(cbind(new_san_net, PI))
# pred_san_net$Season <- factor(pred_san_net$Season, levels = c("Summer","Autumn", "Winter", "Spring"))

# plot of seasonal trend

# ggplot(pred_san_net, aes(Season, log(fit))) + geom_col(position = "dodge") + geom_errorbar(aes(ymin = log(lwr), ymax = log(upr)))


# ggplot(san_net_se, aes(Season, Network_Density, fill = Sex)) + geom_boxplot() + 
#             #geom_line(data = san_net_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("Network Density") + xlab("Season")
# ggplot(san_net_se, aes(Season, Network_Density)) + geom_boxplot() + 
#             #geom_line(data = san_net_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("Network Density") + xlab("Season")





# time of day subset

san_net_dn <- san_daynight
san_net_dn <- san_net_dn[!is.na(san_net_dn$Network_Density),]



# null model
san_net_glmm_null <- glmer(Network_Density ~ 1 + (1|Transmitter.Name), 
data = san_net_dn, family = gaussian(link = "log"))
# summary(san_net_glmm_null)
# r.squaredGLMM(san_net_glmm_null)
san_net_lm_null <- lm(log(Network_Density) ~ 1, data = san_net_dn)
# anova(san_net_glmm_null, san_net_lm_null)

# single variable models
san_net_glmm_sx <- glmer(Network_Density ~ Sex + (1|Transmitter.Name), 
data = san_net_dn, family = gaussian(link = "log"))
# summary(san_net_glmm_sx)
# anova(san_net_glmm_null, san_net_glmm_sx)

san_net_glmm_dn <- glmer(Network_Density ~ Daynight + (1|Transmitter.Name),
 data = san_net_dn, family = gaussian(link = "log"))
# summary(san_net_glmm_dn)
# anova(san_net_glmm_null, san_net_glmm_dn)
# r.squaredGLMM(san_net_glmm_dn)

san_net_aic_dn <- AIC(san_net_glmm_null, san_net_glmm_sx, san_net_glmm_dn)


### Season and time of day combined subsets


# seasons species subsets
net_ti <- san_times
net_ti <- net_ti[!is.na(net_ti$Network_Density),]
net_ti$Season <- factor(net_ti$Season, levels = c("Summer","Autumn", 
"Winter", "Spring"))


# Linear mixed models 

# null model
net_glmm_null <- glmer(Network_Density ~ 1 + (1|Transmitter.Name), 
data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_null)
# r.squaredGLMM(net_glmm_null)
net_lm_null <- lm(log(Network_Density) ~ 1, data = net_ti)
# anova(net_glmm_null, net_lm_null)

# single variable models
net_glmm_sx <- glmer(Network_Density ~ Sex + (1|Transmitter.Name), 
data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_sx)
# anova(net_glmm_null, net_glmm_sx)

net_glmm_se <- glmer(Network_Density ~ Season + (1|Transmitter.Name), 
data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_se)
# anova(net_glmm_null, net_glmm_se)


net_glmm_dn <- glmer(Network_Density ~ daynight + (1|Transmitter.Name), 
data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_dn)
# anova(net_glmm_null, net_glmm_dn)


net_glmm_dnse <- glmer(Network_Density ~ daynight + Season + 
(1|Transmitter.Name), data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_dnse)
# anova(net_glmm_null, net_glmm_dnse)



net_aic_ti <- AIC(net_glmm_null, net_glmm_sx, net_glmm_se,  
net_glmm_dn, net_glmm_dnse)



























##### RESIDENCY INDEX MODELS - ALL #####



# seasons species subsets
san_ri_se <- san_seasons
san_ri_se <- san_ri_se[!is.na(san_ri_se$RI),]
san_ri_se$Season <- factor(san_ri_se$Season, 
levels = c("Summer","Autumn", "Winter", "Spring"))




# # deciding distribution for model
# par(mfrow = c(1,3))
# # normal distribution
# qqp(san_ri_se$RI, "norm")
# # log normal distribution
# qqp(san_ri_se$RI, "lnorm")
# # gamma
# gamma <- fitdistr(san_ri_se$RI, "gamma")
# qqp(san_ri_se$RI, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
# # best fit is log normal



# Linear mixed models 

# null model
san_ri_glmm_null <- glmer(RI ~ 1 + (1|Transmitter.Name), 
data = san_ri_se, family = gaussian(link = "log"))
# summary(san_ri_glmm_null)
# r.squaredGLMM(san_ri_glmm_null)
ri_lm_null <- lm(log(RI) ~ 1, data = san_ri_se)
# anova(san_ri_glmm_null, ri_lm_null)

# single variable models
san_ri_glmm_sx <- glmer(RI ~ Sex + (1|Transmitter.Name), 
data = san_ri_se, family = gaussian(link = "log"))
# summary(san_ri_glmm_sx)
# r.squaredGLMM(san_ri_glmm_sx)
# anova(san_ri_glmm_null, san_ri_glmm_sx)

san_ri_glmm_se <- glmer(RI ~ Season + (1|Transmitter.Name), 
data = san_ri_se, family = gaussian(link = "log"))
# summary(san_ri_glmm_se)
# r.squaredGLMM(san_ri_glmm_se)
# anova(san_ri_glmm_null, san_ri_glmm_se)

san_ri_aic_se <- AIC(san_ri_glmm_null, san_ri_glmm_sx, san_ri_glmm_se)


# ### Model prediction - seasonal variation

# # generate test data

# new_san_ri <- data.frame(cbind(
#     a <- rep(as.character(factor_mode(san_ri_se$Transmitter.Name)),4),
#     b <- c("Summer","Autumn", "Winter", "Spring")
# ))
# colnames(new_san_ri) <- c("Transmitter.Name", "Season")


# # predicted model values
# PI <- predictInterval(san_ri_glmm_se, newdata = new_san_ri, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", 
#                         include.resid.var = TRUE)
# # joined with sample dataset
# pred_san_ri <- cbind(new_san_ri, PI)
# pred_san_ri$Season <- factor(pred_san_ri$Season, 
# levels = c("Summer","Autumn", "Winter", "Spring"))




# # plot of seasonal trend
# ggplot(san_ri_se, aes(Season, log(RI), fill = Sex)) + geom_boxplot() + 
#             #geom_line(data = san_ri_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("RI") + xlab("Season")
# ggplot(san_ri_se, aes(Season, log(RI))) + geom_boxplot() + 
#             #geom_line(data = san_ri_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("RI") + xlab("Season")





# time of day subset

san_ri_dn <- san_daynight
san_ri_dn$RI[san_ri_dn$RI == 0] <- NA
san_ri_dn <- san_ri_dn[!is.na(san_ri_dn$RI),]
san_ri_dn$Daynight <- as.factor(san_ri_dn$Daynight)


# null model
san_ri_glmm_null <- glmer(RI ~ 1 + (1|Transmitter.Name), data = san_ri_dn, 
family = gaussian(link = "log"))
# summary(san_ri_glmm_null)
ri_lm_null <- lm(log(RI) ~ 1, data = san_ri_dn)
# anova(san_ri_glmm_null, ri_lm_null)

# single variable models
san_ri_glmm_sx <- glmer(RI ~ Sex + (1|Transmitter.Name), data = san_ri_dn, 
family = gaussian(link = "log"))
# summary(san_ri_glmm_sx)
# anova(san_ri_glmm_null, san_ri_glmm_sx)

san_ri_glmm_dn <- glmer(RI ~ Daynight + (1|Transmitter.Name), 
data = san_ri_dn, family = gaussian(link = "log"))
# summary(san_ri_glmm_dn)
# r.squaredGLMM(san_ri_glmm_dn)
# anova(san_ri_glmm_null, san_ri_glmm_dn)

san_ri_aic_dn <- AIC(san_ri_glmm_null, san_ri_glmm_sx, san_ri_glmm_dn)

# ### Model prediction - variation between times of day

# # generate test data
# n <- c(as.character(factor_mode(san_ri_dn$Transmitter.Name)), 
#                      as.character(factor_mode(san_ri_dn$Sex)),
#                      as.character(factor_mode(san_ri_dn$Migratory.Status)),
#                      mean(san_ri_dn$FL),
#                      as.character(factor_mode(san_ri_dn$Migratory.Status)),
#                      mean(san_ri_dn$MCP_area), mean(san_ri_dn$core_KUD),
#                      mean(san_ri_dn$Network_Density), mean(san_ri_dn$RI))

# san_ri_dn_newdata <- data.frame(cbind(rbind(n,n), as.character(unique(san_ri_dn$Daynight))))
# colnames(san_ri_dn_newdata) <- c("Transmitter.Name", "Sex", "Migratory.Status", "FL", "Migratory.Status",
#                                     "MCP_area", "core_KUD", "Network_Density",
#                                     "RI", "Daynight")

# # predicted model values
# PI <- predictInterval(san_ri_glmm_dn, newdata = san_ri_dn_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# san_ri_dn_pred <- cbind(san_ri_dn_newdata, PI)

# # plot of seasonal trend
# ggplot(san_ri_dn, aes(Daynight, log(RI))) + geom_boxplot() + 
#             #geom_line(data = san_ri_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("RI") + xlab("Time of Day")



























##### DETECTION RATE MODELS FOR 25M DEPTH BAND - ALL #####

all_det25 <- det25
# remove seasons to test
san_det25 <- subset(all_det25, Species == "Thickskin")

codes <- c()
for(x in unique(san_det25$Transmitter.Name)){
    if(length(unique(san_det25$Date[san_det25$Transmitter.Name == x])) >= 5){
        codes <- append(codes, x)
    }
}

san_det25 <- san_det25[san_det25$Transmitter.Name %in% codes,]

depths <- c()
for(x in unique(san_det25$Depth_band25)){
    if(length(san_det25$Migratory.Status[san_det25$Depth_band25 == x]) >= 5){
        depths <- append(depths, x)
    }
}

san_det25 <- san_det25[san_det25$Depth_band25 %in% depths,]
san_det25$Season <- factor(san_det25$Season, 
levels = c("Summer","Autumn", "Winter", "Spring"))

# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(san_det25$No_Det, "norm")
# # log normal distribution
# qqp(san_det25$No_Det, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(san_det25$No_Det), "Negative Binomial")
# qqp(san_det25$No_Det, "nbinom", size = nbinom$estimate[[1]], 
#mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(san_det25$No_Det), "Poisson")
# qqp(san_det25$No_Det, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(san_det25$No_Det, "gamma")
# qqp(san_det25$No_Det, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
# # best fit is log normal


# Linear mixed models 

# null model
det25_glmm_null <- glmer(No_Det ~ 1 + (1|Transmitter.Name), 
data = san_det25, family = gaussian(link = "log"))
# summary(det25_glmm_null)
# r.squaredGLMM(det25_glmm_null)
det25_lm_null <- lm(log(No_Det) ~ 1, data = san_det25)
# summary(det25_lm_null)


# single variable models
det25_glmm_sx <- glmer(No_Det ~ Sex + (1|Transmitter.Name), 
data = san_det25, family = gaussian(link = "log"))
# summary(det25_glmm_sx)
# r.squaredGLMM(det25_glmm_sx)
# anova(det25_glmm_null, det25_glmm_sx)

det25_glmm_se <- glmer(No_Det ~ Season + (1|Transmitter.Name), 
data = san_det25, family = gaussian(link = "log"))
# summary(det25_glmm_se)
# r.squaredGLMM(det25_glmm_se)
# anova(det25_glmm_null, det25_glmm_se)

det25_glmm_dep <- glmer(No_Det ~ as.factor(Depth_band25) + 
(1|Transmitter.Name), data = san_det25, family = gaussian(link = "log"))
# summary(det25_glmm_dep)
# r.squaredGLMM(det25_glmm_dep)
# anova(det25_glmm_null, det25_glmm_dep)

san_det25_aic <- AIC(det25_glmm_null, det25_glmm_sx, det25_glmm_se, det25_glmm_dep)

# ### Model prediction - variation in detections by season

# # generate test data
# n <- c(as.character(factor_mode(san_det25$Transmitter.Name)), 
#                      as.character(factor_mode(san_det25$Date)),
#                      as.character(factor_mode(san_det25$Sex)),
#                      as.character(factor_mode(san_det25$Migratory.Status)),
#                      mean(san_det25$Depth_band25), mean(san_det25$No_Det),
#                      as.character(factor_mode(san_det25$Migratory.Status)))

# san_det25_newdata <- data.frame(cbind(rbind(n,n,n,n), as.character(unique(san_det25$Season))))
# colnames(san_det25_newdata) <- c("Transmitter.Name","Date","Sex","Migratory.Status","Depth_band25",
#                                 "No_Det","Migratory.Status","Season")

# # predicted model values
# PI <- predictInterval(det25_glmm_se, newdata = san_det25_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# san_det25_pred <- cbind(san_det25_newdata, PI)
# san_det25_pred$Season <- factor(san_det25_pred$Season, levels = c("Summer","Autumn", "Winter", "Spring"))

# # plot of seasonal trend
# ggplot(san_det25, aes(Season, log(No_Det), fill = Sex)) + geom_boxplot() + 
#             #geom_line(data = san_det25_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("No Detections") + xlab("Season")
# ggplot(san_det25, aes(Season, log(No_Det))) + geom_boxplot() + 
#             theme_bw() + ylab("No Detections") + xlab("Season")


# ### Model prediction - variation in number of detections over each depth

# # generate test data
# n <- c(as.character(factor_mode(san_det25$Transmitter.Name)), 
#                      as.character(factor_mode(san_det25$Date)),
#                      as.character(factor_mode(san_det25$Sex)),
#                      as.character(factor_mode(san_det25$Season)),
#                      as.character(factor_mode(san_det25$Migratory.Status)),
#                      mean(san_det25$No_Det),
#                      as.character(factor_mode(san_det25$Migratory.Status)))

# san_det25_newdata <- data.frame(cbind(rbind(n,n,n,n,n), unique(san_det25$Depth_band25)))
# colnames(san_det25_newdata) <- c("Transmitter.Name","Date","Sex","Season","Migratory.Status",
#                                 "No_Det","Migratory.Status","Depth_band25")

# # predicted model values
# PI <- predictInterval(det25_glmm_dep, newdata = san_det25_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# san_det25_pred <- cbind(san_det25_newdata, PI)
# san_det25_pred$Depth_band25 <- factor(san_det25_pred$Depth_band25, levels = c("25","50", "75", "100", "125","150","175"))

# # plot of depth trend
# ggplot(san_det25, aes(as.factor(Depth_band25), log(No_Det))) + geom_boxplot() + theme_bw() 
# ggplot(san_det25, aes(as.factor(Depth_band25), log(No_Det), fill = Season)) + geom_boxplot() + theme_bw() 

# # depths with model values            
# ggplot(san_det25, aes(as.factor(Depth_band25), log(No_Det), fill = Season)) + geom_boxplot() +
#             theme_bw() + ylab("No Detections") + xlab("Depth (m)") 










##### DETECTION RATE MODELS FOR 25M DEPTH BAND - TIME OF DAY #####

all_detdn <- detdn
# remove seasons to test
san_detdn <- all_detdn[all_detdn$Species == "Thickskin",]


codes <- c()
for(x in unique(san_detdn$Transmitter.Name)){
    if(length(unique(san_detdn$Date[san_detdn$Transmitter.Name == x])) >= 5){
        codes <- append(codes, x)
    }
}

san_detdn <- san_detdn[san_detdn$Transmitter.Name %in% codes,]

depths <- c()
for(x in unique(san_detdn$Depth_band25)){
    if(length(san_detdn$Migratory.Status[san_detdn$Depth_band25 == x]) >= 5){
        depths <- append(depths, x)
    }
}

san_detdn <- san_detdn[san_detdn$Depth_band25 %in% depths,]


# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(san_detdn$No_Det, "norm")
# # log normal distribution
# qqp(san_detdn$No_Det, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(san_detdn$No_Det), "Negative Binomial")
# qqp(san_detdn$No_Det, "nbinom", size = nbinom$estimate[[1]], 
#mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(san_detdn$No_Det), "Poisson")
# qqp(san_detdn$No_Det, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(san_detdn$No_Det, "gamma")
# qqp(san_detdn$No_Det, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
# # best fit is log normal


# Linear mixed models 

# null model
detdn_glmm_null <- glmer(No_Det ~ 1 + (1|Transmitter.Name), data = san_detdn, 
family = gaussian(link = "log"))
# summary(detdn_glmm_null)
detdn_lm_null <- lm(log(No_Det) ~ 1, data = san_detdn)


# single variable models
detdn_glmm_sx <- glmer(No_Det ~ Sex + (1|Transmitter.Name), data = san_detdn, 
family = gaussian(link = "log"))
# summary(detdn_glmm_sx)
# anova(detdn_glmm_null, detdn_glmm_sx)

detdn_glmm_dn <- glmer(No_Det ~ daynight + (1|Transmitter.Name), data = san_detdn, 
family = gaussian(link = "log"))
# summary(detdn_glmm_dn)
# r.squaredGLMM(detdn_glmm_dn)
# anova(detdn_glmm_null, detdn_glmm_dn)

detdn_glmm_dep <- glmer(No_Det ~ as.factor(Depth_band25) + (1|Transmitter.Name), 
data = san_detdn, family = gaussian(link = "log"))
# summary(detdn_glmm_dep)
# anova(detdn_glmm_null, detdn_glmm_dep)

san_detdn_aic <- AIC(detdn_glmm_null, detdn_glmm_sx, detdn_glmm_dn, detdn_glmm_dep)

# ### Model prediction - variation in number of detections over each depth

# # generate test data
# n <- c(as.character(factor_mode(san_detdn$Transmitter.Name)), 
#                      as.character(factor_mode(san_detdn$Date)),
#                      as.character(factor_mode(san_detdn$Sex)),
#                      as.character(factor_mode(san_detdn$daynight)),
#                      as.character(factor_mode(san_detdn$Migratory.Status)),
#                      mean(san_detdn$No_Det),
#                      as.character(factor_mode(san_detdn$Migratory.Status)))

# san_detdn_newdata <- data.frame(cbind(rbind(n,n,n,n,n,n), unique(san_detdn$Depth_band25)))
# colnames(san_detdn_newdata) <- c("Transmitter.Name","Date","Sex","daynight","Migratory.Status",
#                                 "No_Det","Migratory.Status","Depth_band25")

# # predicted model values
# PI <- predictInterval(detdn_glmm_dep, newdata = san_detdn_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# san_detdn_pred <- cbind(san_detdn_newdata, PI)
# san_detdn_pred$Depth_band25 <- factor(san_detdn_pred$Depth_band25, levels = c("25","50", "75", "100", "125","150","175"))

# # plot of depth trend
# ggplot(san_detdn, aes(as.factor(Depth_band25), log(No_Det))) + geom_boxplot() + theme_bw() 

# ggplot(san_detdn, aes(as.factor(Depth_band25), log(No_Det), fill = daynight)) + geom_boxplot() + theme_bw() 


