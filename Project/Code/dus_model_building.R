#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: dus_model_building.R
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
time_names <- c("Day_Spring", "Day_Summer", "Day_Autumn","Day_Winter", "Night_Spring", "Night_Summer", "Night_Autumn","Night_Winter")
times <- data.frame()
for(x in time_names){
    a <- att %>% dplyr::select(Transmitter.Name, Species, Sex, FL, Migratory.Status, 
                    paste0("Network_Density_", x))
    colnames(a)[6] <- "Network_Density"
    a$Time <- rep(x, length(a$Transmitter.Name))
    times <- rbind(times, a)
}

times <- separate(times, Time, c("daynight","Season"), sep = "_")


dus_seasons <- seasons[seasons$Species == "Dusky",]
dus_daynight <- daynight[daynight$Species == "Dusky",]
dus_times <- times[times$Species == "Dusky",]









##### CONVEX POLYGONS MODEL - ALL #####

# ## Season subset

# # removing missing values from dataframe and setting to own variable
# dus_MCP_se <- dus_seasons
# dus_MCP_se <- dus_MCP_se[dus_MCP_se$Sex != "U",]
# dus_MCP_se <- dus_MCP_se[!is.na(dus_MCP_se$Migratory.Status),]
# dus_MCP_se <- dus_MCP_se[!is.na(dus_MCP_se$MCP_area),]
# dus_MCP_se$Season <- factor(dus_MCP_se$Season, levels = c("Summer","Autumn", "Winter", "Spring"))


# # deciding distribution for model
# par(mfrow = c(2,2))
# # normal distribution
# qqp(dus_MCP_se$MCP_area, "norm")
# # log normal distribution
# qqp(dus_MCP_se$MCP_area, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(dus_MCP_se$MCP_area), "Negative Binomial")
# qqp(dus_MCP_se$MCP_area, "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(dus_MCP_se$MCP_area), "Poisson")
# qqp(dus_MCP_se$MCP_area, "pois", lambda = poisson$estimate)
# # best fit is normal - none are brilliant fits - checked against reduced seasons

# # Linear mixed models

# # null model
# MCP_glmm_null <- lmer(MCP_area ~ 1 + (1|Transmitter.Name), data = dus_MCP_se, REML = FALSE)
# # summary(MCP_glmm_null)
# MCP_lm_null <- lm(MCP_area ~1, data = dus_MCP_se)
# # anova(MCP_glmm_null, MCP_lm_null)

# # single variable models
# MCP_glmm_sex <- lmer(MCP_area ~ Sex + (1|Transmitter.Name), data = dus_MCP_se, REML = FALSE)
# # summary(MCP_glmm_sex)
# # anova(MCP_glmm_null, MCP_glmm_sex)

# MCP_glmm_sea <- lmer(MCP_area ~ Season + (1|Transmitter.Name), data = dus_MCP_se, REML = FALSE)
# # summary(MCP_glmm_sea)
# # anova(MCP_glmm_null, MCP_glmm_sea)

# MCP_glmm_sp <- lmer(MCP_area ~ Migratory.Status + (1|Transmitter.Name), data = dus_MCP_se, REML = FALSE)
# # summary(MCP_glmm_sp)
# # anova(MCP_glmm_null, MCP_glmm_sp)



# ## Time of day subset

# # removing missing values from dataframe and setting to own variable
# dus_MCP_dn <- dus_daynight
# dus_MCP_dn <- dus_MCP_dn[dus_MCP_dn$Sex != "U",]
# dus_MCP_dn <- dus_MCP_dn[!is.na(dus_MCP_dn$Migratory.Status),]
# dus_MCP_dn <- dus_MCP_dn[!is.na(dus_MCP_dn$MCP_area),]

# # null model
# MCP_glmm_null <- lmer(MCP_area ~ 1 + (1|Transmitter.Name), data = dus_MCP_dn, REML = FALSE)
# # summary(MCP_glmm_null)
# MCP_lm_null <- lm(MCP_area ~1, data = dus_MCP_dn)
# # anova(MCP_glmm_null, MCP_lm_null)

# # single variable models
# MCP_glmm_sex <- lmer(MCP_area ~ Sex + (1|Transmitter.Name), data = dus_MCP_dn, REML = FALSE)
# # summary(MCP_glmm_sex)
# # anova(MCP_glmm_null, MCP_glmm_sex)

# MCP_glmm_dn <- lmer(MCP_area ~ Daynight + (1|Transmitter.Name), data = dus_MCP_dn, REML = FALSE)
# # summary(MCP_glmm_dn)
# # anova(MCP_glmm_null, MCP_glmm_dn)

# MCP_glmm_mig <- lmer(MCP_area ~ Migratory.Status + (1|Transmitter.Name), data = dus_MCP_dn, REML = FALSE)
# # summary(MCP_glmm_mig)
# # anova(MCP_glmm_null, MCP_glmm_mig)


















##### CORE KERNEL DENSITY MODEL - ALL #####


# seasons subsets

dus_KUD_se <- dus_seasons
dus_KUD_se <- dus_KUD_se[dus_KUD_se$Sex != "U",]
dus_KUD_se <- dus_KUD_se[!is.na(dus_KUD_se$Migratory.Status),]
dus_KUD_se <- dus_KUD_se[!is.na(dus_KUD_se$core_KUD),]
dus_KUD_se$Season <- factor(dus_KUD_se$Season, levels = c("Summer",
"Autumn", "Winter", "Spring"))


# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(dus_KUD_se$core_KUD, "norm")
# # log normal distribution
# qqp(dus_KUD_se$core_KUD, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(dus_KUD_se$core_KUD), "Negative Binomial")
# qqp(dus_KUD_se$core_KUD, "nbinom", size = nbinom$estimate[[1]], 
#mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(dus_KUD_se$core_KUD), "Poisson")
# qqp(dus_KUD_se$core_KUD, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(dus_KUD_se$core_KUD, "gamma")
# qqp(dus_KUD_se$core_KUD, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
# best fit is gamma - normal distribution also close


# Linear mixed models 

# null model
KUD_glmm_null <- glmer(core_KUD ~ 1 + (1|Transmitter.Name), data = dus_KUD_se, 
family = Gamma)
# summary(KUD_glmm_null)
KUD_lm_null <- lm(core_KUD ~ 1, data = dus_KUD_se)
# anova(KUD_glmm_null, KUD_lm_null)

# single variable models
KUD_glmm_sx <- glmer(core_KUD ~ Sex + (1|Transmitter.Name), data = dus_KUD_se, 
family = Gamma)
# summary(KUD_glmm_sx)
# anova(KUD_glmm_null, KUD_glmm_sx)

KUD_glmm_se <- glmer(core_KUD ~ Season + (1|Transmitter.Name), data = dus_KUD_se, 
family = Gamma)
# summary(KUD_glmm_se)
# anova(KUD_glmm_null, KUD_glmm_se)

KUD_glmm_mig <- glmer(core_KUD ~ Migratory.Status + (1|Transmitter.Name), 
data = dus_KUD_se, family = Gamma)
# summary(KUD_glmm_mig)
# anova(KUD_glmm_null, KUD_glmm_mig)

dus_kud_aic_se <- AIC(KUD_glmm_null, KUD_glmm_sx, KUD_glmm_se, KUD_glmm_mig)

## Time of day subset

# removing missing values from dataframe and setting to own variable
dus_KUD_dn <- dus_daynight
dus_KUD_dn <- dus_KUD_dn[dus_KUD_dn$Sex != "U",]
dus_KUD_dn <- dus_KUD_dn[!is.na(dus_KUD_dn$Migratory.Status),]
dus_KUD_dn <- dus_KUD_dn[!is.na(dus_KUD_dn$core_KUD),]


# Linear mixed models 

# null model
KUD_glmm_null <- glmer(core_KUD ~ 1 + (1|Transmitter.Name), data = dus_KUD_dn, 
family = Gamma)
# summary(KUD_glmm_null)
KUD_lm_null <- lm(core_KUD ~ 1, data = dus_KUD_dn)
# anova(KUD_glmm_null, KUD_lm_null)

# single variable models
KUD_glmm_sx <- glmer(core_KUD ~ Sex + (1|Transmitter.Name), data = dus_KUD_dn, 
family = Gamma)
# summary(KUD_glmm_sx)
# anova(KUD_glmm_null, KUD_glmm_sx)

KUD_glmm_dn <- glmer(core_KUD ~ Daynight + (1|Transmitter.Name), data = dus_KUD_dn, 
family = Gamma)
# summary(KUD_glmm_dn)
# anova(KUD_glmm_null, KUD_glmm_dn)

KUD_glmm_mig <- glmer(core_KUD ~ Migratory.Status + (1|Transmitter.Name), 
data = dus_KUD_dn, family = Gamma)
# summary(KUD_glmm_mig)
# anova(KUD_glmm_null, KUD_glmm_mig)

dus_kud_aic_dn <- AIC(KUD_glmm_null, KUD_glmm_sx, KUD_glmm_dn, KUD_glmm_mig)


















##### NETWORK DENSITY MODELS - ALL #####



# seasons species subsets
dus_net_se <- dus_seasons
dus_net_se <- dus_net_se[dus_net_se$Sex != "U",]
dus_net_se <- dus_net_se[!is.na(dus_net_se$Migratory.Status),]
dus_net_se <- dus_net_se[!is.na(dus_net_se$Network_Density),]
dus_net_se$Season <- factor(dus_net_se$Season, 
levels = c("Summer","Autumn", "Winter", "Spring"))




# deciding distribution for model
# par(mfrow = c(1,3))
# # normal distribution
# qqp(dus_net_se$Network_Density, "norm")
# # log normal distribution
# qqp(dus_net_se$Network_Density, "lnorm")
# # gamma
# gamma <- fitdistr(dus_net_se$Network_Density, "gamma")
# qqp(dus_net_se$Network_Density, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
# # best fit is log normal



# Linear mixed models 

# null model
dus_net_glmm_null <- glmer(Network_Density ~ 1 + (1|Transmitter.Name), 
data = dus_net_se, family = gaussian(link = "log"))
# summary(dus_net_glmm_null)
# r.squaredGLMM(dus_net_glmm_null)
dus_net_lm_null <- lm(log(Network_Density) ~ 1, data = dus_net_se)
# anova(dus_net_glmm_null, dus_net_lm_null)

# single variable models
dus_net_glmm_sx <- glmer(Network_Density ~ Sex + (1|Transmitter.Name), 
data = dus_net_se, family = gaussian(link = "log"))
# summary(dus_net_glmm_sx)
# anova(dus_net_glmm_null, dus_net_glmm_sx)
# r.squaredGLMM(dus_net_glmm_sx)

dus_net_glmm_se <- glmer(Network_Density ~ Season + (1|Transmitter.Name), 
data = dus_net_se, family = gaussian(link = "log"))
# summary(dus_net_glmm_se)
# anova(dus_net_glmm_null, dus_net_glmm_se)
# r.squaredGLMM(dus_net_glmm_se)

dus_net_glmm_mig <- glmer(Network_Density ~ Migratory.Status + (1|Transmitter.Name),
 data = dus_net_se, family = gaussian(link = "log"))
# summary(dus_net_glmm_mig)
# anova(dus_net_glmm_null, dus_net_glmm_mig)
# r.squaredGLMM(dus_net_glmm_mig)

dus_net_aic_se <- AIC(dus_net_glmm_sx, dus_net_glmm_se, dus_net_glmm_mig)

### Model prediction - seasonal variation

# # generate test data
# n <- c(as.character(factor_mode(dus_net_se$Transmitter.Name)), 
#                      as.character(factor_mode(dus_net_se$Migratory.Status)),
#                      as.character(factor_mode(dus_net_se$Sex)),
#                      mean(dus_net_se$FL),
#                      as.character(factor_mode(dus_net_se$Migratory.Status)),
#                      mean(dus_net_se$MCP_area), mean(dus_net_se$core_KUD),
#                      mean(dus_net_se$Network_Density), mean(dus_net_se$RI))

# dus_net_se_newdata <- data.frame(cbind(rbind(n,n,n,n), as.character(unique(dus_net_se$Season))))
# colnames(dus_net_se_newdata) <- names(dus_net_se)

# # predicted model values
# PI <- predictInterval(dus_net_glmm_se, newdata = dus_net_se_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# dus_net_se_pred <- cbind(dus_net_se_newdata, PI)
# dus_net_se_pred$Season <- factor(dus_net_se_pred$Season, levels = c("Summer","Autumn", "Winter", "Spring"))

# # plot of seasonal trend
# ggplot(dus_net_se, aes(Season, Network_Density, fill = Migratory.Status)) + geom_boxplot() + 
#             #geom_line(data = dus_net_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("Network Density") + xlab("Season")
# ggplot(dus_net_se, aes(Season, Network_Density)) + geom_boxplot() + 
#             #geom_line(data = dus_net_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("Network Density") + xlab("Season")





# time of day subset

dus_net_dn <- dus_daynight
dus_net_dn <- dus_net_dn[dus_net_dn$Sex != "U",]
dus_net_dn <- dus_net_dn[!is.na(dus_net_dn$Migratory.Status),]
dus_net_dn <- dus_net_dn[!is.na(dus_net_dn$Network_Density),]



# null model
dus_net_glmm_null <- glmer(Network_Density ~ 1 + (1|Transmitter.Name), 
data = dus_net_dn, family = gaussian(link = "log"))
# summary(dus_net_glmm_null)
# r.squaredGLMM(dus_net_glmm_null)
dus_net_lm_null <- lm(log(Network_Density) ~ 1, data = dus_net_dn)
# anova(dus_net_glmm_null, dus_net_lm_null)

# single variable models
dus_net_glmm_sx <- glmer(Network_Density ~ Sex + (1|Transmitter.Name), 
data = dus_net_dn, family = gaussian(link = "log"))
# summary(dus_net_glmm_sx)
# anova(dus_net_glmm_null, dus_net_glmm_sx)

dus_net_glmm_dn <- glmer(Network_Density ~ Daynight + (1|Transmitter.Name), 
data = dus_net_dn, family = gaussian(link = "log"))
# summary(dus_net_glmm_dn)
# anova(dus_net_glmm_null, dus_net_glmm_dn)
# r.squaredGLMM(dus_net_glmm_dn)

dus_net_glmm_mig <- glmer(Network_Density ~ Migratory.Status + (1|Transmitter.Name), 
data = dus_net_dn, family = gaussian(link = "log"))
# summary(dus_net_glmm_mig)
# anova(dus_net_glmm_null, dus_net_glmm_mig)

dus_net_aic_dn <- AIC(dus_net_glmm_null, dus_net_glmm_sx, dus_net_glmm_dn, 
dus_net_glmm_mig)

# ### Model prediction - variation between times of day

# # generate test data
# n <- c(as.character(factor_mode(dus_net_dn$Transmitter.Name)), 
#                      as.character(factor_mode(dus_net_dn$Sex)),
#                      as.character(factor_mode(dus_net_dn$Migratory.Status)),
#                      mean(dus_net_dn$FL),
#                      as.character(factor_mode(dus_net_dn$Migratory.Status)),
#                      mean(dus_net_dn$MCP_area), mean(dus_net_dn$core_KUD),
#                      mean(dus_net_dn$Network_Density), mean(dus_net_dn$RI))

# dus_net_dn_newdata <- data.frame(cbind(rbind(n,n), as.character(unique(dus_net_dn$Daynight))))
# colnames(dus_net_dn_newdata) <- c("Transmitter.Name", "Sex", "Migratory.Status", "FL", "Migratory.Status",
#                                     "MCP_area", "core_KUD", "Network_Density",
#                                     "RI", "Daynight")

# # predicted model values
# PI <- predictInterval(dus_net_glmm_dn, newdata = dus_net_dn_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# dus_net_dn_pred <- cbind(dus_net_dn_newdata, PI)

# # plot of seasonal trend
# ggplot(dus_net_dn, aes(Daynight, Network_Density)) + geom_boxplot() + 
#             #geom_line(data = dus_net_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("Network Density") + xlab("Time of Day")
# ggplot(dus_net_dn, aes(Daynight, Network_Density, fill = Migratory.Status)) + geom_boxplot() + 
#             #geom_line(data = dus_net_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("Network Density") + xlab("Time of Day")



### Season and time of day combined subsets


# seasons species subsets
net_ti <- dus_times
net_ti <- net_ti[net_ti$Sex != "U",]
net_ti <- net_ti[!is.na(net_ti$Network_Density),]
net_ti <- net_ti[!is.na(net_ti$Migratory.Status),]
net_ti$Season <- factor(net_ti$Season, 
levels = c("Summer","Autumn", "Winter", "Spring"))



# Linear mixed models 

# null model
net_glmm_null <- glmer(Network_Density ~ 1 + (1|Transmitter.Name), data = net_ti, 
family = gaussian(link = "log"))
# summary(net_glmm_null)
# r.squaredGLMM(net_glmm_null)
net_lm_null <- lm(log(Network_Density) ~ 1, data = net_ti)
# anova(net_glmm_null, net_lm_null)

# single variable models
net_glmm_sx <- glmer(Network_Density ~ Sex + (1|Transmitter.Name), data = net_ti, 
family = gaussian(link = "log"))
# summary(net_glmm_sx)
# anova(net_glmm_null, net_glmm_sx)

net_glmm_se <- glmer(Network_Density ~ Season + (1|Transmitter.Name), data = net_ti, 
family = gaussian(link = "log"))
# summary(net_glmm_se)
# anova(net_glmm_null, net_glmm_se)


net_glmm_dn <- glmer(Network_Density ~ daynight + (1|Transmitter.Name), 
data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_dn)
# anova(net_glmm_null, net_glmm_dn)


net_glmm_mig <- glmer(Network_Density ~ Migratory.Status + (1|Transmitter.Name), 
data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_mig)
# anova(net_glmm_null, net_glmm_dn)


net_glmm_dnse <- glmer(Network_Density ~ daynight + Season + (1|Transmitter.Name), 
data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_dnse)
# anova(net_glmm_null, net_glmm_dnse)



net_aic_ti <- AIC(net_glmm_null, net_lm_null, net_glmm_sx, net_glmm_se, net_glmm_dn,
 net_glmm_dnse, net_glmm_mig)




























##### RESIDENCY INDEX MODELS - ALL #####



# seasons species subsets
dus_ri_se <- dus_seasons
dus_ri_se <- dus_ri_se[dus_ri_se$Sex != "U",]
dus_ri_se <- dus_ri_se[!is.na(dus_ri_se$Migratory.Status),]
dus_ri_se <- dus_ri_se[!is.na(dus_ri_se$RI),]
dus_ri_se$Season <- factor(dus_ri_se$Season, 
levels = c("Summer","Autumn", "Winter", "Spring"))




# # deciding distribution for model
# par(mfrow = c(1,3))
# # normal distribution
# qqp(dus_ri_se$RI, "norm")
# # log normal distribution
# qqp(dus_ri_se$RI, "lnorm")
# # gamma
# gamma <- fitdistr(dus_ri_se$RI, "gamma")
# qqp(dus_ri_se$RI, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
# # best fit is log normal



# Linear mixed models 

# null model
dus_ri_glmm_null <- glmer(RI ~ 1 + (1|Transmitter.Name), data = dus_ri_se, 
family = gaussian(link = "log"))
# summary(dus_ri_glmm_null)
# r.squaredGLMM(dus_ri_glmm_null)
ri_lm_null <- lm(log(RI) ~ 1, data = dus_ri_se)
# anova(dus_ri_glmm_null, ri_lm_null)

# single variable models
dus_ri_glmm_sx <- glmer(RI ~ Sex + (1|Transmitter.Name), data = dus_ri_se, 
family = gaussian(link = "log"))
# summary(dus_ri_glmm_sx)
# r.squaredGLMM(dus_ri_glmm_sx)
# anova(dus_ri_glmm_null, dus_ri_glmm_sx)

dus_ri_glmm_se <- glmer(RI ~ Season + (1|Transmitter.Name), data = dus_ri_se, 
family = gaussian(link = "log"))
# summary(dus_ri_glmm_se)
# r.squaredGLMM(dus_ri_glmm_se)
# anova(dus_ri_glmm_null, dus_ri_glmm_se)

dus_ri_glmm_mig <- glmer(RI ~ Migratory.Status + (1|Transmitter.Name) , 
data = dus_ri_se, family = gaussian(link = "log"))
# summary(dus_ri_glmm_mig)
# r.squaredGLMM(dus_ri_glmm_mig)
# anova(dus_ri_glmm_null, dus_ri_glmm_mig)

dus_ri_aic_se <- AIC(dus_ri_glmm_null, dus_ri_glmm_sx, dus_ri_glmm_se, 
dus_ri_glmm_mig)

### Model prediction - seasonal variation

# # generate test data
# n <- c(as.character(factor_mode(dus_ri_se$Transmitter.Name)), 
#                      as.character(factor_mode(dus_ri_se$Migratory.Status)),
#                      as.character(factor_mode(dus_ri_se$Sex)),
#                      mean(dus_ri_se$FL),
#                      as.character(factor_mode(dus_ri_se$Migratory.Status)),
#                      mean(dus_ri_se$MCP_area), mean(dus_ri_se$core_KUD),
#                      mean(dus_ri_se$Network_Density), mean(dus_ri_se$RI))

# dus_ri_se_newdata <- data.frame(cbind(rbind(n,n,n,n), 
# as.character(unique(dus_ri_se$Season))))
# colnames(dus_ri_se_newdata) <- names(dus_ri_se)

# # predicted model values
# PI <- predictInterval(dus_ri_glmm_se, newdata = dus_ri_se_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", 
#                         include.resid.var = TRUE)
# # joined with sample dataset
# dus_ri_se_pred <- cbind(dus_ri_se_newdata, PI)
# dus_ri_se_pred$Season <- factor(dus_ri_se_pred$Season, 
# levels = c("Summer","Autumn", "Winter", "Spring"))

# # plot of seasonal trend
# ggplot(dus_ri_se, aes(Season, log(RI), fill = Migratory.Status)) + geom_boxplot() + 
#             #geom_line(data = dus_ri_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("RI") + xlab("Season")
# ggplot(dus_ri_se, aes(Season, log(RI))) + geom_boxplot() + 
#             #geom_line(data = dus_ri_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("RI") + xlab("Season")

# ggplot(dus_ri_se, aes(Migratory.Status, log(RI), fill = Season)) + geom_boxplot() + 
#             #geom_line(data = dus_ri_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("RI") + xlab("Migratory.Status")





# time of day subset

dus_ri_dn <- dus_daynight
dus_ri_dn <- dus_ri_dn[dus_ri_dn$Sex != "U",]
dus_ri_dn <- dus_ri_dn[!is.na(dus_ri_dn$Migratory.Status),]
dus_ri_dn$RI[dus_ri_dn$RI == 0] <- NA
dus_ri_dn <- dus_ri_dn[!is.na(dus_ri_dn$RI),]
dus_ri_dn$Daynight <- as.factor(dus_ri_dn$Daynight)


# null model
dus_ri_glmm_null <- glmer(RI ~ 1 + (1|Transmitter.Name), data = dus_ri_dn, 
family = gaussian(link = "log"))
# summary(dus_ri_glmm_null)
ri_lm_null <- lm(log(RI) ~ 1, data = dus_ri_dn)
# anova(dus_ri_glmm_null, ri_lm_null)

# single variable models
dus_ri_glmm_sx <- glmer(RI ~ Sex + (1|Transmitter.Name), data = dus_ri_dn, 
family = gaussian(link = "log"))
# summary(dus_ri_glmm_sx)
# anova(dus_ri_glmm_null, dus_ri_glmm_sx)

dus_ri_glmm_dn <- glmer(RI ~ Daynight + (1|Transmitter.Name), data = dus_ri_dn, 
family = gaussian(link = "log"))
# summary(dus_ri_glmm_dn)
# r.squaredGLMM(dus_ri_glmm_dn)
# anova(dus_ri_glmm_null, dus_ri_glmm_dn)

dus_ri_glmm_mig <- glmer(RI ~ Migratory.Status + (1|Transmitter.Name) + 
(1|Daynight), data = dus_ri_dn, family = gaussian(link = "log"))
# summary(dus_ri_glmm_mig)
# anova(dus_ri_glmm_null, dus_ri_glmm_mig)


dus_ri_aic_dn <- AIC(dus_ri_glmm_null, dus_ri_glmm_sx, dus_ri_glmm_dn, 
dus_ri_glmm_mig)


# ### Model prediction - variation between times of day

# # generate test data
# n <- c(as.character(factor_mode(dus_ri_dn$Transmitter.Name)), 
#                      as.character(factor_mode(dus_ri_dn$Sex)),
#                      as.character(factor_mode(dus_ri_dn$Migratory.Status)),
#                      mean(dus_ri_dn$FL),
#                      as.character(factor_mode(dus_ri_dn$Migratory.Status)),
#                      mean(dus_ri_dn$MCP_area), mean(dus_ri_dn$core_KUD),
#                      mean(dus_ri_dn$Network_Density), mean(dus_ri_dn$RI))

# dus_ri_dn_newdata <- data.frame(cbind(rbind(n,n), as.character(unique(dus_ri_dn$Daynight))))
# colnames(dus_ri_dn_newdata) <- c("Transmitter.Name", "Sex", "Migratory.Status", "FL", "Migratory.Status",
#                                     "MCP_area", "core_KUD", "Network_Density",
#                                     "RI", "Daynight")

# # predicted model values
# PI <- predictInterval(dus_ri_glmm_dn, newdata = dus_ri_dn_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# dus_ri_dn_pred <- cbind(dus_ri_dn_newdata, PI)

# # plot of seasonal trend
# ggplot(dus_ri_dn, aes(Daynight, log(RI), fill = Migratory.Status)) + geom_boxplot() + 
#             #geom_line(data = dus_ri_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("RI") + xlab("Time of Day")
# ggplot(dus_ri_dn, aes(Migratory.Status, log(RI), fill = Daynight)) + geom_boxplot() + 
#             #geom_line(data = dus_ri_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("RI") + xlab("Migratory Status")




























##### DETECTION RATE MODELS FOR 25M DEPTH BAND - ALL #####

all_det25 <- det25
# remove seasons to test
all_det25 <- all_det25[all_det25$Sex != "U",]
dus_det25 <- subset(all_det25, Species == "Dusky")
dus_det25 <- dus_det25[!is.na(dus_det25$Migratory.Status),]

codes <- c()
for(x in unique(dus_det25$Transmitter.Name)){
    if(length(unique(dus_det25$Date[dus_det25$Transmitter.Name == x])) >= 5){
        codes <- append(codes, x)
    }
}

dus_det25 <- dus_det25[dus_det25$Transmitter.Name %in% codes,]

depths <- c()
for(x in unique(dus_det25$Depth_band25)){
    if(length(dus_det25$Migratory.Status[dus_det25$Depth_band25 == x]) >= 5){
        depths <- append(depths, x)
    }
}

dus_det25 <- dus_det25[dus_det25$Depth_band25 %in% depths,]
dus_det25$Season <- factor(dus_det25$Season, 
levels = c("Summer","Autumn", "Winter", "Spring"))

# deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(dus_det25$No_Det, "norm")
# # log normal distribution
# qqp(dus_det25$No_Det, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(dus_det25$No_Det), "Negative Binomial")
# qqp(dus_det25$No_Det, "nbinom", size = nbinom$estimate[[1]], 
#mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(dus_det25$No_Det), "Poisson")
# qqp(dus_det25$No_Det, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(dus_det25$No_Det, "gamma")
# qqp(dus_det25$No_Det, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
# # best fit is log normal


# Linear mixed models 

# null model
det25_glmm_null <- glmer(No_Det ~ 1 + (1|Transmitter.Name), 
data = dus_det25, family = gaussian(link = "log"))
# summary(det25_glmm_null)
# r.squaredGLMM(det25_glmm_null)
det25_lm_null <- lm(log(No_Det) ~ 1, data = dus_det25)
# summary(det25_lm_null)


# single variable models
det25_glmm_sx <- glmer(No_Det ~ Sex + (1|Transmitter.Name), 
data = dus_det25, family = gaussian(link = "log"))
# summary(det25_glmm_sx)
# r.squaredGLMM(det25_glmm_sx)
# anova(det25_glmm_null, det25_glmm_sx)

det25_glmm_se <- glmer(No_Det ~ Season + (1|Transmitter.Name), 
data = dus_det25, family = gaussian(link = "log"))
# summary(det25_glmm_se)
# r.squaredGLMM(det25_glmm_se)
# anova(det25_glmm_null, det25_glmm_se)

det25_glmm_mig <- glmer(No_Det ~ Migratory.Status + (1|Transmitter.Name), 
data = dus_det25, family = gaussian(link = "log"))
# summary(det25_glmm_mig)
# r.squaredGLMM(det25_glmm_mig)
# anova(det25_glmm_null, det25_glmm_mig)

det25_glmm_dep <- glmer(No_Det ~ as.factor(Depth_band25) + (1|Transmitter.Name), 
data = dus_det25, family = gaussian(link = "log"))
# summary(det25_glmm_dep)
# r.squaredGLMM(det25_glmm_dep)
# anova(det25_glmm_null, det25_glmm_dep)

dus_det25_aic <- AIC(det25_glmm_null, det25_glmm_sx, det25_glmm_se,det25_glmm_mig, 
det25_glmm_dep)

### Model prediction - variation in detections by season

# # generate test data
# n <- c(as.character(factor_mode(dus_det25$Transmitter.Name)), 
#                      as.character(factor_mode(dus_det25$Date)),
#                      as.character(factor_mode(dus_det25$Sex)),
#                      as.character(factor_mode(dus_det25$Migratory.Status)),
#                      mean(dus_det25$Depth_band25), mean(dus_det25$No_Det),
#                      as.character(factor_mode(dus_det25$Migratory.Status)))

# dus_det25_newdata <- data.frame(cbind(rbind(n,n,n,n), as.character(unique(dus_det25$Season))))
# colnames(dus_det25_newdata) <- c("Transmitter.Name","Date","Sex","Migratory.Status","Depth_band25",
#                                 "No_Det","Migratory.Status","Season")

# # predicted model values
# PI <- predictInterval(det25_glmm_se, newdata = dus_det25_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# dus_det25_pred <- cbind(dus_det25_newdata, PI)
# dus_det25_pred$Season <- factor(dus_det25_pred$Season, levels = c("Summer","Autumn", "Winter", "Spring"))

# # plot of seasonal trend
# ggplot(dus_det25, aes(as.factor(Depth_band25), log(No_Det), fill = Season)) + geom_boxplot() + 
#             #geom_line(data = dus_det25_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("No Detections") + xlab("Season")
# ggplot(dus_det25, aes(Season, log(No_Det))) + geom_boxplot() + 
#             geom_line(data = dus_det25_pred, aes(as.numeric(Season), log(fit))) +
#             theme_bw() + ylab("No Detections") + xlab("Season")


### Model prediction - variation in number of detections over each depth

# generate test data
# n <- c(as.character(factor_mode(dus_det25$Transmitter.Name)), 
#                      as.character(factor_mode(dus_det25$Date)),
#                      as.character(factor_mode(dus_det25$Sex)),
#                      as.character(factor_mode(dus_det25$Season)),
#                      as.character(factor_mode(dus_det25$Migratory.Status)),
#                      mean(dus_det25$No_Det),
#                      as.character(factor_mode(dus_det25$Migratory.Status)))

# dus_det25_newdata <- data.frame(cbind(rbind(n,n,n,n,n), unique(dus_det25$Depth_band25)))
# colnames(dus_det25_newdata) <- c("Transmitter.Name","Date","Sex","Season","Migratory.Status",
#                                 "No_Det","Migratory.Status","Depth_band25")

# # predicted model values
# PI <- predictInterval(det25_glmm_dep, newdata = dus_det25_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# dus_det25_pred <- cbind(dus_det25_newdata, PI)
# dus_det25_pred$Depth_band25 <- factor(dus_det25_pred$Depth_band25, levels = c("25","50", "75", "100", "125","150","175"))

# # plot of depth trend
# ggplot(dus_det25, aes(as.factor(Depth_band25), log(No_Det))) + geom_boxplot() + theme_bw() 
# ggplot(dus_det25, aes(as.factor(Depth_band25), log(No_Det), fill = Season)) + geom_boxplot() + theme_bw() 

# # depths with model values            
# ggplot(dus_det25, aes(as.numeric(as.character(Depth_band25)), log(No_Det))) + geom_point() +
#             theme_bw() + ylab("No Detections") + xlab("Depth (m)") +
#             geom_line(data = dus_det25_pred, aes(y = log(fit)), colour = "blue") +
#             geom_line(data = dus_det25_pred, aes(y = log(upr)), colour = "red", linetype = "dashed") +
#             geom_line(data = dus_det25_pred, aes(y = log(lwr)), colour = "red", linetype = "dashed")











##### DETECTION RATE MODELS FOR 25M DEPTH BAND - TIME OF DAY #####

all_detdn <- detdn
# remove seasons to test
all_detdn <- all_detdn[all_detdn$Sex != "U",]
dus_detdn <- all_detdn[all_detdn$Species == "Dusky",]
dus_detdn <- dus_detdn[!is.na(dus_detdn$Migratory.Status),]

codes <- c()
for(x in unique(dus_detdn$Transmitter.Name)){
    if(length(unique(dus_detdn$Date[dus_detdn$Transmitter.Name == x])) >= 5){
        codes <- append(codes, x)
    }
}

dus_detdn <- dus_detdn[dus_detdn$Transmitter.Name %in% codes,]

depths <- c()
for(x in unique(dus_detdn$Depth_band25)){
    if(length(dus_detdn$Migratory.Status[dus_detdn$Depth_band25 == x]) >= 5){
        depths <- append(depths, x)
    }
}

dus_detdn <- dus_detdn[dus_detdn$Depth_band25 %in% depths,]


# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(dus_detdn$No_Det, "norm")
# # log normal distribution
# qqp(dus_detdn$No_Det, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(dus_detdn$No_Det), "Negative Binomial")
# qqp(dus_detdn$No_Det, "nbinom", size = nbinom$estimate[[1]], 
#mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(dus_detdn$No_Det), "Poisson")
# qqp(dus_detdn$No_Det, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(dus_detdn$No_Det, "gamma")
# qqp(dus_detdn$No_Det, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
# # best fit is log normal


# Linear mixed models 

# null model
detdn_glmm_null <- glmer(No_Det ~ 1 + (1|Transmitter.Name), data = dus_detdn, 
family = gaussian(link = "log"))
# summary(detdn_glmm_null)
detdn_lm_null <- lm(log(No_Det) ~ 1, data = dus_detdn)


# single variable models
detdn_glmm_sx <- glmer(No_Det ~ Sex + (1|Transmitter.Name), data = dus_detdn, 
family = gaussian(link = "log"))
# summary(detdn_glmm_sx)
# anova(detdn_glmm_null, detdn_glmm_sx)

detdn_glmm_dn <- glmer(No_Det ~ daynight + (1|Transmitter.Name), data = dus_detdn, 
family = gaussian(link = "log"))
# summary(detdn_glmm_dn)
# r.squaredGLMM(detdn_glmm_dn)
# anova(detdn_glmm_null, detdn_glmm_dn)

detdn_glmm_mig <- glmer(No_Det ~ Migratory.Status + (1|Transmitter.Name), 
data = dus_detdn, family = gaussian(link = "log"))
# summary(detdn_glmm_mig)
# anova(detdn_glmm_null, detdn_glmm_mig)

detdn_glmm_dep <- glmer(No_Det ~ as.factor(Depth_band25) + (1|Transmitter.Name), 
data = dus_detdn, family = gaussian(link = "log"))
# summary(detdn_glmm_dep)
# anova(detdn_glmm_null, detdn_glmm_dep)

dus_detdn_aic <- AIC(detdn_glmm_null, detdn_glmm_sx, detdn_glmm_dn, detdn_glmm_mig, 
detdn_glmm_dep)

### Model prediction - variation in number of detections over each depth

# # generate test data
# n <- c(as.character(factor_mode(dus_detdn$Transmitter.Name)), 
#                      as.character(factor_mode(dus_detdn$Date)),
#                      as.character(factor_mode(dus_detdn$Sex)),
#                      as.character(factor_mode(dus_detdn$daynight)),
#                      as.character(factor_mode(dus_detdn$Migratory.Status)),
#                      mean(dus_detdn$No_Det),
#                      as.character(factor_mode(dus_detdn$Migratory.Status)))

# dus_detdn_newdata <- data.frame(cbind(rbind(n,n,n,n,n,n), unique(dus_detdn$Depth_band25)))
# colnames(dus_detdn_newdata) <- c("Transmitter.Name","Date","Sex","daynight","Migratory.Status",
#                                 "No_Det","Migratory.Status","Depth_band25")

# # predicted model values
# PI <- predictInterval(detdn_glmm_dep, newdata = dus_detdn_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# dus_detdn_pred <- cbind(dus_detdn_newdata, PI)
# dus_detdn_pred$Depth_band25 <- factor(dus_detdn_pred$Depth_band25, levels = c("25","50", "75", "100", "125","150","175"))

# # plot of depth trend
# ggplot(dus_detdn, aes(as.factor(Depth_band25), log(No_Det))) + geom_boxplot() + theme_bw() 

# ggplot(dus_detdn, aes(as.factor(Depth_band25), log(No_Det), fill = daynight)) + geom_boxplot() + theme_bw() 