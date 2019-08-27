#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: model_building_all.R
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
# require(cluster)
# require(factoextra)
# require(dendextend)




# load datasets
att <- read.csv("../Data/shark_attributes.csv", header = TRUE)
# det10 <- read.csv("../Data/detection_perday10.csv", header = TRUE)
det25 <- read.csv("../Data/detection_perday25.csv", header = TRUE)
# # det50 <- read.csv("../Data/detection_perday50.csv", header = TRUE)
# det <- read.csv("../Data/detection_perday.csv", header = TRUE)
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




# ##### CONVEX POLYGONS MODEL - ALL #####

# ## Season subset

# # removing missing values from dataframe and setting to own variable
# MCP_se <- seasons
# MCP_se <- MCP_se[MCP_se$Sex != "U",]
# MCP_se <- MCP_se[!is.na(MCP_se$MCP_area),]
# MCP_se$Season <- factor(MCP_se$Season, levels = c("Summer","Autumn", "Winter", "Spring"))


# # deciding distribution for model
# par(mfrow = c(2,2))
# # normal distribution
# qqp(MCP_se$MCP_area, "norm")
# # log normal distribution
# qqp(MCP_se$MCP_area, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(MCP_se$MCP_area), "Negative Binomial")
# qqp(MCP_se$MCP_area, "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(MCP_se$MCP_area), "Poisson")
# qqp(MCP_se$MCP_area, "pois", lambda = poisson$estimate)
# # best fit is normal - none are brilliant fits - checked against reduced seasons

# # Linear mixed models

# # null model
# MCP_glmm_null <- lmer(MCP_area ~ 1 + (1|Transmitter.Name), data = MCP_se, REML = FALSE)
# # summary(MCP_glmm_null)
# MCP_lm_null <- lm(MCP_area ~1, data = MCP_se)
# # anova(MCP_glmm_null, MCP_lm_null)

# # single variable models
# MCP_glmm_sex <- lmer(MCP_area ~ Sex + (1|Transmitter.Name), data = MCP_se, REML = FALSE)
# # summary(MCP_glmm_sex)
# # anova(MCP_glmm_null, MCP_glmm_sex)

# MCP_glmm_sea <- lmer(MCP_area ~ Season + (1|Transmitter.Name), data = MCP_se, REML = FALSE)
# # summary(MCP_glmm_sea)
# # anova(MCP_glmm_null, MCP_glmm_sea)

# MCP_glmm_sp <- lmer(MCP_area ~ Species + (1|Transmitter.Name), data = MCP_se, REML = FALSE)
# # summary(MCP_glmm_sp)
# # anova(MCP_glmm_null, MCP_glmm_sp)

# MCP_aic_se <- AIC(MCP_glmm_null, MCP_lm_null, MCP_glmm_sex, MCP_glmm_sea, MCP_glmm_sp)


# ## Time of day subset

# # removing missing values from dataframe and setting to own variable
# MCP_dn <- daynight
# MCP_dn <- MCP_dn[MCP_dn$Sex != "U",]
# MCP_dn <- MCP_dn[!is.na(MCP_dn$MCP_area),]

# # null model
# MCP_glmm_null <- lmer(MCP_area ~ 1 + (1|Transmitter.Name), data = MCP_dn, REML = FALSE)
# # summary(MCP_glmm_null)
# MCP_lm_null <- lm(MCP_area ~1, data = MCP_dn)
# # anova(MCP_glmm_null, MCP_lm_null)

# # single variable models
# MCP_glmm_sex <- lmer(MCP_area ~ Sex + (1|Transmitter.Name), data = MCP_dn, REML = FALSE)
# # summary(MCP_glmm_sex)
# # anova(MCP_glmm_null, MCP_glmm_sex)

# MCP_glmm_dn <- lmer(MCP_area ~ Daynight + (1|Transmitter.Name), data = MCP_dn, REML = FALSE)
# # summary(MCP_glmm_dn)
# # anova(MCP_glmm_null, MCP_glmm_dn)

# MCP_glmm_sp <- lmer(MCP_area ~ Species + (1|Transmitter.Name), data = MCP_dn, REML = FALSE)
# # summary(MCP_glmm_sp)
# # anova(MCP_glmm_null, MCP_glmm_sp)


# MCP_aic_dn <- AIC(MCP_glmm_null, MCP_lm_null, MCP_glmm_sex, MCP_glmm_dn, MCP_glmm_sp)















##### CORE KERNEL DENSITY MODEL - ALL #####


# seasons subsets

KUD_se <- seasons
KUD_se <- KUD_se[KUD_se$Sex != "U",]
KUD_se <- KUD_se[!is.na(KUD_se$core_KUD),]
KUD_se$Season <- factor(KUD_se$Season, levels = c("Summer","Autumn", 
"Winter", "Spring"))


# deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(KUD_se$core_KUD, "norm")
# # log normal distribution
# qqp(KUD_se$core_KUD, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(KUD_se$core_KUD), "Negative Binomial")
# qqp(KUD_se$core_KUD, "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(KUD_se$core_KUD), "Poisson")
# qqp(KUD_se$core_KUD, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(KUD_se$core_KUD, "gamma")
# qqp(KUD_se$core_KUD, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
# # best fit is gamma - normal distribution also close


# Linear mixed models 

# null model
KUD_glmm_null <- glmer(core_KUD ~ 1 + (1|Transmitter.Name), data = KUD_se, 
family = Gamma)
# # summary(KUD_glmm_null)
KUD_lm_null <- lm(core_KUD ~ 1, data = KUD_se)
# # anova(KUD_glmm_null, KUD_lm_null)

# single variable models
KUD_glmm_sx <- glmer(core_KUD ~ Sex + (1|Transmitter.Name), data = KUD_se, 
family = Gamma)
# # summary(KUD_glmm_sx)
# # anova(KUD_glmm_null, KUD_glmm_sx)

KUD_glmm_se <- glmer(core_KUD ~ Season + (1|Transmitter.Name), data = KUD_se, 
family = Gamma)
# # summary(KUD_glmm_se)
# # anova(KUD_glmm_null, KUD_glmm_se)

KUD_glmm_sp <- glmer(core_KUD ~ Species + (1|Transmitter.Name), data = KUD_se, 
family = Gamma)
# # summary(KUD_glmm_sp)
# # anova(KUD_glmm_null, KUD_glmm_sp)

KUD_aid_se <- AIC(KUD_glmm_null, KUD_lm_null, KUD_glmm_sx, KUD_glmm_se, KUD_glmm_sp)
# best fit = model with species


# plot of core KUD density

KUD_plot_sp <- ggplot(KUD_se, aes(core_KUD, fill = Species, alpha = I(0.4))) + 
geom_density() + theme_bw() +
                xlab("Core Kernel Utilisation Distribution Area") + 
                ylab("Proportion of Individuals") + 
                guides(fill = "none") + 
                scale_fill_manual(values = c("deepskyblue2", "darkgoldenrod1")) +
                theme(axis.text=element_text(size=11), 
                axis.title=element_text(size=12))

pdf("../Results/KUD_densityplot_sp.pdf")
KUD_plot_sp
graphics.off()

## Time of day subset

# removing missing values from dataframe and setting to own variable
KUD_dn <- daynight
KUD_dn <- KUD_dn[KUD_dn$Sex != "U",]
KUD_dn <- KUD_dn[!is.na(KUD_dn$core_KUD),]


# Linear mixed models 

# null model
KUD_glmm_null <- glmer(core_KUD ~ 1 + (1|Transmitter.Name), data = KUD_dn, 
family = Gamma)
# summary(KUD_glmm_null)
KUD_lm_null <- lm(core_KUD ~ 1, data = KUD_dn)
# anova(KUD_glmm_null, KUD_lm_null)

# single variable models
KUD_glmm_sx <- glmer(core_KUD ~ Sex + (1|Transmitter.Name), data = KUD_dn, 
family = Gamma)
# summary(KUD_glmm_sx)
# anova(KUD_glmm_null, KUD_glmm_sx)

KUD_glmm_dn <- glmer(core_KUD ~ Daynight + (1|Transmitter.Name), data = KUD_dn, 
family = Gamma)
# summary(KUD_glmm_dn)
# anova(KUD_glmm_null, KUD_glmm_dn)

KUD_glmm_sp <- glmer(core_KUD ~ Species + (1|Transmitter.Name), data = KUD_dn, 
family = Gamma)
# summary(KUD_glmm_sp)
# anova(KUD_glmm_null, KUD_glmm_sp)

KUD_aid_dn <- AIC(KUD_glmm_null, KUD_lm_null, KUD_glmm_sx, KUD_glmm_dn, KUD_glmm_sp)


















##### NETWORK DENSITY MODELS - ALL #####

# seasons species subsets
net_se <- seasons
net_se <- net_se[net_se$Sex != "U",]
net_se <- net_se[!is.na(net_se$Network_Density),]
net_se$Season <- factor(net_se$Season, levels = c("Summer","Autumn", 
"Winter", "Spring"))




# # deciding distribution for model
# par(mfrow = c(1,3))
# # normal distribution
# qqp(net_se$Network_Density, "norm")
# # log normal distribution
# qqp(net_se$Network_Density, "lnorm")
# # gamma
# gamma <- fitdistr(net_se$Network_Density, "gamma")
# qqp(net_se$Network_Density, "gamma", shape = gamma$estimate[[1]], 
# rate = gamma$estimate[[2]])
# # best fit is log normal



# Linear mixed models 

# null model
net_glmm_null <- glmer(Network_Density ~ 1 + (1|Transmitter.Name), 
data = net_se, family = gaussian(link = "log"))
# summary(net_glmm_null)
# r.squaredGLMM(net_glmm_null)
net_lm_null <- lm(log(Network_Density) ~ 1, data = net_se)
# anova(net_glmm_null, net_lm_null)

# single variable models
net_glmm_sx <- glmer(Network_Density ~ Sex + (1|Transmitter.Name), 
data = net_se, family = gaussian(link = "log"))
# summary(net_glmm_sx)
# anova(net_glmm_null, net_glmm_sx)
# r.squaredGLMM(net_glmm_sx)

net_glmm_se <- glmer(Network_Density ~ Season + (1|Transmitter.Name), 
data = net_se, family = gaussian(link = "log"))
# summary(net_glmm_se)
# anova(net_glmm_null, net_glmm_se)
# r.squaredGLMM(net_glmm_se)

net_glmm_sp <- glmer(Network_Density ~ Species + (1|Transmitter.Name), 
data = net_se, family = gaussian(link = "log"))
# summary(net_glmm_sp)
# anova(net_glmm_null, net_glmm_sp)
# r.squaredGLMM(net_glmm_sp)

net_aic_se <- AIC(net_glmm_null, net_lm_null, net_glmm_sx, net_glmm_se, net_glmm_sp)

### Model prediction - seasonal variation


# generate test data

# a <- net_se %>% dplyr::select(Transmitter.Name, Species)
# a <- unique(a)
# a_new <- rbind(a,a,a,a)

# b <- c(rep("Summer",length(a[,1])),rep("Autumn",length(a[,1])),rep("Winter",length(a[,1])),rep("Spring",length(a[,1])))


# new_data_net <- data.frame(cbind(a_new,b))
# colnames(new_data_net) <- c("Transmitter.Name", "Species", "Season")

# # predicted model values
# PI <- predictInterval(net_glmm_se, newdata = new_data_net, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# pred_data_net <- data.frame(cbind(new_data_net, PI))
# pred_data_net$Season <- factor(pred_data_net$Season, levels = c("Summer","Autumn", "Winter", "Spring"))

# # plot of seasonal trend - new predicted values

# net_pred_plot <- ggplot(pred_data_net, aes(Season, (fit), fill = Species)) + geom_col(position = "dodge") + 
#         geom_errorbar(aes(ymin = log(lwr), ymax = mean(upr), group = Species, alpha = I(0.5)), position = "dodge")

# net_plot_sesp <- ggplot(net_se, aes(Season, Network_Density, fill = Species)) + geom_boxplot() + 
#             #geom_line(data = net_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("Network Density") + xlab("Season")


# net_se$Species_latin <- factor(net_se$Species, levels = c("Dusky", "Sandbar"),
#                   labels = c("C. obscurus", "C. plumbeus"))

# net_plot_se <- ggplot(net_se, aes(Season, Network_Density)) + geom_boxplot() + 
#             theme_bw() + ylab("Average Network Density") + xlab("Season") +
#             facet_wrap("Species_latin") + 
#             theme(strip.background = element_rect(color="black", fill="white", linetype=0),
#             strip.text = element_text(size = 11, face = "italic", hjust = 0),
#             axis.text=element_text(size=11), axis.title=element_text(size=12))






## Paired bar chart for network density

net_se$Species_latin <- factor(net_se$Species, levels = c("Dusky", "Sandbar"),
                  labels = c("C. obscurus", "C. plumbeus"))



se <- function(x){ sqrt(var(x)/length(x))}

sp <- c()
sea <- c()
me <- c()
sd <- c()
for(x in unique(net_se$Species)){
    a <- subset(net_se, Species == x)
    for(i in unique(a$Season)){
        b <- subset(a, Season == i)
        sp <- append(sp, x)
        sea <- append(sea, i)
        me <- append(me, mean(b$Network_Density))
        sd <- append(sd, se(b$Network_Density))
    }
}

df_net <- data.frame(cbind(sp, sea, me, sd))
colnames(df_net) <- c("Species", "Season","Av","SE")
df_net$Season <- factor(df_net$Season, levels = c("Summer","Autumn", "Winter", "Spring"))
df_net$Av <- as.numeric(as.character(df_net$Av))
df_net$SE <- as.numeric(as.character(df_net$SE))

df_net$Species_latin <- factor(df_net$Species, levels = c("Dusky", "Sandbar"),
                        labels = c("C. obscurus", "C. plumbeus")) 


net_plot_se <-  ggplot(df_net, aes(Season, Av)) + 
                geom_bar(stat = "identity", color = "black", fill = "grey") + 
                geom_errorbar(aes(ymin = Av-SE, ymax = Av+SE), width = 0.2) +      
                theme_bw() + ylab("Average Network Density") + xlab("Season") + 
                facet_wrap("Species_latin") + 
                theme(strip.background = element_rect(color="black", fill="white", 
                linetype=0),
                strip.text = element_text(size = 11, face = "italic", hjust = 0),
                axis.text=element_text(size=11), axis.title=element_text(size=12))



pdf("../Results/network_season.pdf", 8,4.5)
net_plot_se
graphics.off()








# time of day subset

net_dn <- daynight
net_dn <- net_dn[net_dn$Sex != "U",]
net_dn <- net_dn[!is.na(net_dn$Network_Density),]



# null model
net_glmm_null <- glmer(Network_Density ~ 1 + (1|Transmitter.Name), data = net_dn, 
family = gaussian(link = "log"))
# summary(net_glmm_null)
# r.squaredGLMM(net_glmm_null)
net_lm_null <- lm(log(Network_Density) ~ 1, data = net_dn)
# anova(net_glmm_null, net_lm_null)

# single variable models
net_glmm_sx <- glmer(Network_Density ~ Sex + (1|Transmitter.Name), data = net_dn, 
family = gaussian(link = "log"))
# summary(net_glmm_sx)
# anova(net_glmm_null, net_glmm_sx)


net_glmm_dn <- glmer(Network_Density ~ Daynight + (1|Transmitter.Name), 
data = net_dn, family = gaussian(link = "log"))
# summary(net_glmm_dn)
# anova(net_glmm_null, net_glmm_dn)
# r.squaredGLMM(net_glmm_dn)

net_glmm_sp <- glmer(Network_Density ~ Species + (1|Transmitter.Name), 
data = net_dn, family = gaussian(link = "log"))
# summary(net_glmm_sp)
# anova(net_glmm_null, net_glmm_sp)


net_aic_dn <- AIC(net_glmm_null, net_lm_null, net_glmm_sx, net_glmm_dn, net_glmm_sp)

### Model prediction - variation between times of day

# generate test data

n


n <- c(as.character(factor_mode(net_dn$Transmitter.Name)), 
                     as.character(factor_mode(net_dn$Sex)),
                     as.character(factor_mode(net_dn$Species)),
                     mean(net_dn$FL),
                     as.character(factor_mode(net_dn$Migratory.Status)),
                     mean(net_dn$MCP_area), mean(net_dn$core_KUD),
                     mean(net_dn$Network_Density), mean(net_dn$RI))

net_dn_newdata <- data.frame(cbind(rbind(n,n), as.character(unique(net_dn$Daynight))))
colnames(net_dn_newdata) <- c("Transmitter.Name", "Sex", "Species", "FL", 
"Migratory.Status",
                                    "MCP_area", "core_KUD", "Network_Density",
                                    "RI", "Daynight")

# predicted model values
PI <- predictInterval(net_glmm_dn, newdata = net_dn_newdata, level = 0.95,
                        n.sims = 1000, stat = "median", type = "probability", 
                        include.resid.var = TRUE)
# joined with sample dataset
net_dn_pred <- cbind(net_dn_newdata, PI)

# plot of seasonal trend
net_plot_dn <- ggplot(net_dn, aes(Daynight, Network_Density)) + geom_boxplot() + 
            #geom_line(data = net_se_pred, aes(as.numeric(Season), fit)) +
            theme_bw() + ylab("Network Density") + xlab("Time of Day")
net_plot_dnsp <- ggplot(net_dn, aes(Daynight, Network_Density, fill = Species)) 
+ geom_boxplot() + 
            #geom_line(data = net_se_pred, aes(as.numeric(Season), fit)) +
            theme_bw() + ylab("Network Density") + xlab("Time of Day")




### Season and time of day combined subsets


# seasons species subsets
net_ti <- times
net_ti <- net_ti[net_ti$Sex != "U",]
net_ti <- net_ti[!is.na(net_ti$Network_Density),]
net_ti$Season <- factor(net_ti$Season, levels = c("Summer","Autumn", "Winter", 
"Spring"))




# # deciding distribution for model
# par(mfrow = c(1,3))
# # normal distribution
# qqp(net_ti$Network_Density, "norm")
# # log normal distribution
# qqp(net_ti$Network_Density, "lnorm")
# # gamma
# gamma <- fitdistr(net_ti$Network_Density, "gamma")
# qqp(net_ti$Network_Density, "gamma", shape = gamma$estimate[[1]], 
# rate = gamma$estimate[[2]])
# # best fit is log normal



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

net_glmm_sp <- glmer(Network_Density ~ Species + (1|Transmitter.Name), data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_sp)
# anova(net_glmm_null, net_glmm_sp)


net_glmm_dn <- glmer(Network_Density ~ daynight + (1|Transmitter.Name), 
data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_dn)
# anova(net_glmm_null, net_glmm_dn)


net_glmm_dnse <- glmer(Network_Density ~ daynight + Season + (1|Transmitter.Name), 
data = net_ti, family = gaussian(link = "log"))
# summary(net_glmm_dnse)
# anova(net_glmm_null, net_glmm_dnse)



net_aic_ti <- AIC(net_glmm_null, net_lm_null, net_glmm_sx, net_glmm_se, net_glmm_sp, 
net_glmm_dn, net_glmm_dnse)























##### RESIDENCY INDEX MODELS - ALL #####

# seasons species subsets
ri_se <- seasons
ri_se <- ri_se[ri_se$Sex != "U",]
ri_se <- ri_se[!is.na(ri_se$RI),]
ri_se$Season <- factor(ri_se$Season, levels = c("Summer",
"Autumn", "Winter", "Spring"))




# # deciding distribution for model
# par(mfrow = c(1,3))
# # normal distribution
# qqp(ri_se$RI, "norm")
# # log normal distribution
# qqp(ri_se$RI, "lnorm")
# # gamma
# gamma <- fitdistr(ri_se$RI, "gamma")
# qqp(ri_se$RI, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
# # best fit is log normal



# Linear mixed models 

# null model
ri_glmm_null <- glmer(RI ~ 1 + (1|Transmitter.Name), data = ri_se, 
family = gaussian(link = "log"))
# summary(ri_glmm_null)
# r.squaredGLMM(ri_glmm_null)
ri_lm_null <- lm(log(RI) ~ 1, data = ri_se)
# anova(ri_glmm_null, ri_lm_null)

# single variable models
ri_glmm_sx <- glmer(RI ~ Sex + (1|Transmitter.Name), data = ri_se, 
family = gaussian(link = "log"))
# summary(ri_glmm_sx)
# r.squaredGLMM(ri_glmm_sx)
# anova(ri_glmm_null, ri_glmm_sx)

ri_glmm_se <- glmer(RI ~ Season + (1|Transmitter.Name), data = ri_se, 
family = gaussian(link = "log"))
# summary(ri_glmm_se)
# r.squaredGLMM(ri_glmm_se)
# anova(ri_glmm_null, ri_glmm_se)

ri_glmm_sp <- glmer(RI ~ Species + (1|Transmitter.Name), data = ri_se, 
family = gaussian(link = "log"))
# summary(ri_glmm_sp)
# r.squaredGLMM(ri_glmm_sp)
# anova(ri_glmm_null, ri_glmm_sp)

ri_aic_se <- AIC(ri_glmm_null, ri_lm_null, ri_glmm_sx, ri_glmm_se, ri_glmm_sp)

### Model prediction - seasonal variation

# generate test data
# n <- c(as.character(factor_mode(ri_se$Transmitter.Name)), 
#                      as.character(factor_mode(ri_se$Species)),
#                      as.character(factor_mode(ri_se$Sex)),
#                      mean(ri_se$FL),
#                      as.character(factor_mode(ri_se$Migratory.Status)),
#                      mean(ri_se$MCP_area), mean(ri_se$core_KUD),
#                      mean(ri_se$Network_Density), mean(ri_se$RI))

# ri_se_newdata <- data.frame(cbind(rbind(n,n,n,n), as.character(unique(ri_se$Season))))
# colnames(ri_se_newdata) <- names(ri_se)

# # predicted model values
# PI <- predictInterval(ri_glmm_se, newdata = ri_se_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# ri_se_pred <- cbind(ri_se_newdata, PI)
# ri_se_pred$Season <- factor(ri_se_pred$Season, levels = c("Summer","Autumn", "Winter", "Spring"))

# # plot of seasonal trend
# ri_plot_sesp <- ggplot(ri_se, aes(Season, log(RI), fill = Species)) + geom_boxplot() + 
#             #geom_line(data = ri_se_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("RI") + xlab("Season")





ri_se$Species_latin <- factor(ri_se$Species, levels = c("Dusky", "Sandbar"),
                  labels = c("C. obscurus", "C. plumbeus"))



se <- function(x){ sqrt(var(x)/length(x))}

sp <- c()
sea <- c()
me <- c()
sd <- c()
for(x in unique(ri_se$Species)){
    a <- subset(ri_se, Species == x)
    for(i in unique(a$Season)){
        b <- subset(a, Season == i)
        sp <- append(sp, x)
        sea <- append(sea, i)
        me <- append(me, mean(b$RI))
        sd <- append(sd, se(b$RI))
    }
}

df_ri <- data.frame(cbind(sp, sea, me, sd))
colnames(df_ri) <- c("Species", "Season","Av","SE")
df_ri$Season <- factor(df_ri$Season, levels = c("Summer","Autumn", "Winter", "Spring"))
df_ri$Av <- as.numeric(as.character(df_ri$Av))
df_ri$SE <- as.numeric(as.character(df_ri$SE))

df_ri$Species_latin <- factor(df_ri$Species, levels = c("Dusky", "Sandbar"),
                        labels = c("C. obscurus", "C. plumbeus")) 

ri_plot_se <-   ggplot(df_ri, aes(Season, Av)) + 
                geom_bar(stat = "identity", color = "black", fill = "grey") + 
                geom_errorbar(aes(ymin = Av-SE, ymax = Av+SE), width = 0.2) +      
                theme_bw() + ylab("Residency Index") + xlab("Season") + 
                facet_wrap("Species_latin") + 
                theme(strip.background = element_rect(color="black", fill="white", 
                linetype=0),
                strip.text = element_text(size = 11, face = "italic", hjust = 0),
                axis.text=element_text(size=11), axis.title=element_text(size=12))

pdf("../Results/ri_season.pdf", 8,4.5)
ri_plot_se
graphics.off()






# time of day subset

ri_dn <- daynight
ri_dn <- ri_dn[ri_dn$Sex != "U",]
ri_dn$RI[ri_dn$RI == 0] <- NA
ri_dn <- ri_dn[!is.na(ri_dn$RI),]
ri_dn$Daynight <- as.factor(ri_dn$Daynight)



# null model
ri_glmm_null <- glmer(RI ~ 1 + (1|Transmitter.Name), data = ri_dn, 
family = gaussian(link = "log"))
# summary(ri_glmm_null)
ri_lm_null <- lm(log(RI) ~ 1, data = ri_dn)
# anova(ri_glmm_null, ri_lm_null)

# single variable models
ri_glmm_sx <- glmer(RI ~ Sex + (1|Transmitter.Name), data = ri_dn, 
family = gaussian(link = "log"))
# summary(ri_glmm_sx)
# anova(ri_glmm_null, ri_glmm_sx)

ri_glmm_dn <- glmer(RI ~ Daynight + (1|Transmitter.Name), data = ri_dn, 
family = gaussian(link = "log"))
# summary(ri_glmm_dn)
# r.squaredGLMM(ri_glmm_dn)
# anova(ri_glmm_null, ri_glmm_dn)

ri_glmm_sp <- glmer(RI ~ Species + (1|Transmitter.Name), data = ri_dn, 
family = gaussian(link = "log"))
# summary(ri_glmm_sp)
# anova(ri_glmm_null, ri_glmm_sp)

ri_aic_dn <- AIC(ri_glmm_null, ri_lm_null, ri_glmm_sx, ri_glmm_dn, ri_glmm_sp)
# best fit = time of day

### Model prediction - variation between times of day

# generate test data
n <- c(as.character(factor_mode(ri_dn$Transmitter.Name)), 
                     as.character(factor_mode(ri_dn$Sex)),
                     as.character(factor_mode(ri_dn$Species)),
                     mean(ri_dn$FL),
                     as.character(factor_mode(ri_dn$Migratory.Status)),
                     mean(ri_dn$MCP_area), mean(ri_dn$core_KUD),
                     mean(ri_dn$Network_Density), mean(ri_dn$RI))

ri_dn_newdata <- data.frame(cbind(rbind(n,n), as.character(unique(ri_dn$Daynight))))
colnames(ri_dn_newdata) <- c("Transmitter.Name", "Sex", "Species", "FL", 
"Migratory.Status",
                                    "MCP_area", "core_KUD", "Network_Density",
                                    "RI", "Daynight")

# predicted model values
PI <- predictInterval(ri_glmm_dn, newdata = ri_dn_newdata, level = 0.95,
                        n.sims = 1000, stat = "median", type = "probability", 
                        include.resid.var = TRUE)
# joined with sample dataset
ri_dn_pred <- cbind(ri_dn_newdata, PI)



# plot of seasonal trend
ri_plot_dn <- ggplot(ri_dn, aes(Daynight, log(RI))) + geom_boxplot() + 
            #geom_line(data = ri_se_pred, aes(as.numeric(Season), fit)) +
            theme_bw() + ylab("RI") + xlab("Time of Day")
ri_plot_dnsp <- ggplot(ri_dn, aes(Daynight, log(RI), fill = Species)) + 
geom_boxplot() + 
            #geom_line(data = ri_se_pred, aes(as.numeric(Season), fit)) +
            theme_bw() + ylab("RI") + xlab("Time of Day")



































##### DETECTION RATE MODELS FOR 25M DEPTH BAND - ALL #####

all_det25 <- det25
# remove seasons to test
all_det25 <- all_det25[all_det25$Sex != "U",]

depths <- c()
for(x in unique(all_det25$Depth_band25)){
    if(length(all_det25$Species[all_det25$Depth_band25 == x]) >= 5){
        depths <- append(depths, x)
    }
}

all_det25 <- all_det25[all_det25$Depth_band25 %in% depths,]
all_det25$Season <- factor(all_det25$Season, levels = c("Summer","Autumn", 
"Winter", "Spring"))

# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(all_det25$No_Det, "norm")
# # log normal distribution
# qqp(all_det25$No_Det, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(all_det25$No_Det), "Negative Binomial")
# qqp(all_det25$No_Det, "nbinom", size = nbinom$estimate[[1]], 
#mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(all_det25$No_Det), "Poisson")
# qqp(all_det25$No_Det, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(all_det25$No_Det, "gamma")
# qqp(all_det25$No_Det, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
# # best fit is log normal


# Linear mixed models 

# null model
det25_glmm_null <- glmer(No_Det ~ 1 + (1|Transmitter.Name), data = all_det25, 
family = gaussian(link = "log"))
# summary(det25_glmm_null)
# r.squaredGLMM(det25_glmm_null)
det25_lm_null <- lm(log(No_Det) ~ 1, data = all_det25)
# summary(det25_lm_null)


# single variable models
det25_glmm_sx <- glmer(No_Det ~ Sex + (1|Transmitter.Name), data = all_det25, 
family = gaussian(link = "log"))
# summary(det25_glmm_sx)
# r.squaredGLMM(det25_glmm_sx)
# anova(det25_glmm_null, det25_glmm_sx)

det25_glmm_se <- glmer(No_Det ~ Season + (1|Transmitter.Name), data = all_det25, 
family = gaussian(link = "log"))
# summary(det25_glmm_se)
# r.squaredGLMM(det25_glmm_se)
# anova(det25_glmm_null, det25_glmm_se)

det25_glmm_sp <- glmer(No_Det ~ Species + (1|Transmitter.Name), data = all_det25, 
family = gaussian(link = "log"))
# summary(det25_glmm_sp)
# r.squaredGLMM(det25_glmm_sp)
# anova(det25_glmm_null, det25_glmm_sp)

det25_glmm_dep <- glmer(No_Det ~ as.factor(Depth_band25) + (1|Transmitter.Name), 
data = all_det25, family = gaussian(link = "log"))
# summary(det25_glmm_dep)
# r.squaredGLMM(det25_glmm_dep)
# anova(det25_glmm_null, det25_glmm_dep)


# two variable models
# most sig factors
det25_glmm_deprse <- glmer(No_Det ~ as.factor(Depth_band25) + (1|Season) + 
(1|Transmitter.Name), data = all_det25, family = gaussian(link = "log"))
# summary(det25_glmm_deprse)

det25_glmm_depse <- glmer(No_Det ~ as.factor(Depth_band25) + Season + 
(1|Transmitter.Name), data = all_det25, family = gaussian(link = "log"))
# summary(det25_glmm_depse)

# anova(det25_glmm_null, det25_glmm_depse, det25_glmm_deprse)

det25_aic_se <- AIC(det25_glmm_null, det25_lm_null, det25_glmm_sx, det25_glmm_se, 
det25_glmm_sp, det25_glmm_dep, det25_glmm_depse, det25_glmm_deprse)


### Model prediction - variation in detections by season by depth band

# # generate test data
# a <- rep(factor_mode(all_det25$Transmitter.Name), 24)
# b <- rep(as.character(factor_mode(all_det25$Sex)), 24)
# c <- rep(as.character(factor_mode(all_det25$Species)), 24)
# d <- rep(mean(all_det25$No_Det),24)
# e <- rep(as.character(factor_mode(all_det25$Migratory.Status)), 24)

# new_data <- data.frame(cbind(as.character(a), b, c, d, e))
# colnames(new_data) <- c("Transmitter.Name","Sex","Species",
#                                 "No_Det","Migratory.Status")

# new_data$Season <- rep(season_names, 6)
# new_data$Depth_band25 <- as.factor(c(rep(25,4), rep(50,4), rep(75,4), rep(100,4), 
# rep(125,4), rep(175,4)))

# # predicted model values
# PI <- predictInterval(det25_glmm_depse, newdata = new_data, level = 0.05,
#                         n.sims = 1000, stat = "median", type = "probability", 
#                         include.resid.var = TRUE)
# # joined with sample dataset
# new_det_pred <- cbind(new_data, PI)
# new_det_pred$Season <- factor(all_det25_pred$Season, levels = c("Summer","Autumn", 
# "Winter", "Spring"))

# # plot of seasonal trend

# new_sum <- new_det_pred[new_det_pred$Season == "Summer",]
# spline_sum <- as.data.frame(spline(new_sum$Depth_band25, new_sum$fit))
# spline_sumupr <- as.data.frame(spline(new_sum$Depth_band25, new_sum$upr))
# spline_sumlwr <- as.data.frame(spline(new_sum$Depth_band25, new_sum$lwr))
# new_aut <- new_det_pred[new_det_pred$Season == "Autumn",]
# spline_aut <- as.data.frame(spline(new_aut$Depth_band25, new_aut$fit))
# spline_autupr <- as.data.frame(spline(new_aut$Depth_band25, new_aut$upr))
# spline_autlwr <- as.data.frame(spline(new_aut$Depth_band25, new_aut$lwr))
# new_win <- new_det_pred[new_det_pred$Season == "Winter",]
# spline_win <- as.data.frame(spline(new_win$Depth_band25, new_win$fit))
# spline_winupr <- as.data.frame(spline(new_win$Depth_band25, new_win$upr))
# spline_winlwr <- as.data.frame(spline(new_win$Depth_band25, new_win$lwr))
# new_spr <- new_det_pred[new_det_pred$Season == "Spring",]
# spline_spr <- as.data.frame(spline(new_spr$Depth_band25, new_spr$fit))
# spline_sprupr <- as.data.frame(spline(new_spr$Depth_band25, new_spr$upr))
# spline_sprlwr <- as.data.frame(spline(new_spr$Depth_band25, new_spr$lwr))



# ggplot(new_det_pred) +
# geom_line(data = spline_sum, aes(x,log(y), colour = 2)) + geom_line(data = spline_sumlwr, aes(x,log(y),colour = 2)) + geom_line(data = spline_autupr, aes(x,log(y)))

# ggplot(new_det_pred, aes(Depth_band25,fit)) + geom_line() #+ geom_line(aes(Depth_band25,upr)) + geom_line(aes(Depth_band25,lwr))


# graphics.off()

# det_plot_deppred <- ggplot(all_det25_pred, aes(as.numeric(as.character(Depth_band25)), log(fit))) + 
#             geom_smooth() +  theme_bw() + ylab("No Detections") + xlab("Depth (m)") + facet_wrap("Season")
#             geom_line(data = all_det25_pred, aes(y = log(fit)), colour = "blue") +
#             geom_line(data = all_det25_pred, aes(y = log(upr)), colour = "red", linetype = "dashed") +
#             geom_line(data = all_det25_pred, aes(y = log(lwr)), colour = "red", linetype = "dashed")



# det_plot_sedep <- ggplot(all_det25, aes(Season, log(No_Det), fill = as.factor(Depth_band25))) + geom_boxplot() + 
#             #geom_line(data = all_det25_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("No Detections") + xlab("Season")
# det_plot_se <- ggplot(all_det25, aes(Season, log(No_Det))) + geom_boxplot() + 
#             geom_line(data = all_det25_pred, aes(as.numeric(Season), log(fit))) +
#             theme_bw() + ylab("No Detections") + xlab("Season")


# ### Model prediction - variation in number of detections over each depth

# # generate test data
# n <- c(as.character(factor_mode(all_det25$Transmitter.Name)), 
#                      as.character(factor_mode(all_det25$Date)),
#                      as.character(factor_mode(all_det25$Sex)),
#                      as.character(factor_mode(all_det25$Season)),
#                      as.character(factor_mode(all_det25$Species)),
#                      mean(all_det25$No_Det),
#                      as.character(factor_mode(all_det25$Migratory.Status)))

# all_det25_newdata <- data.frame(cbind(rbind(n,n,n,n,n), unique(all_det25$Depth_band25)))
# colnames(all_det25_newdata) <- c("Transmitter.Name","Date","Sex","Season","Species",
#                                 "No_Det","Migratory.Status","Depth_band25")

# # predicted model values
# PI <- predictInterval(det25_glmm_dep, newdata = all_det25_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# all_det25_pred <- cbind(all_det25_newdata, PI)
# all_det25_pred$Depth_band25 <- factor(all_det25_pred$Depth_band25, levels = c("25","50", "75", "100", "125","150","175"))

# # plot of depth trend
# det_plot_dep <- ggplot(all_det25, aes(as.factor(Depth_band25), log(No_Det))) + geom_boxplot() + theme_bw() 

# # depths with model values            
# det_plot_deppred <- ggplot(all_det25, aes(as.numeric(as.character(Depth_band25)), log(No_Det))) + geom_point() +
#             theme_bw() + ylab("No Detections") + xlab("Depth (m)") +
#             geom_line(data = all_det25_pred, aes(y = log(fit)), colour = "blue") +
#             geom_line(data = all_det25_pred, aes(y = log(upr)), colour = "red", linetype = "dashed") +
#             geom_line(data = all_det25_pred, aes(y = log(lwr)), colour = "red", linetype = "dashed")

# # depth plot divided by season
# det_plot_depse <- ggplot(all_det25, aes(as.factor(Depth_band25), log(No_Det))) + 
#                 geom_boxplot() + theme_bw() + facet_wrap("Season")










##### DETECTION RATE MODELS FOR 25M DEPTH BAND - TIME OF DAY #####

all_detdn <- detdn
# remove seasons to test
all_detdn <- all_detdn[all_detdn$Sex != "U",]

codes <- c()
for(x in unique(all_detdn$Transmitter.Name)){
    if(length(unique(all_detdn$Date[all_detdn$Transmitter.Name == x])) >= 5){
        codes <- append(codes, x)
    }
}

all_detdn <- all_detdn[all_detdn$Transmitter.Name %in% codes,]

depths <- c()
for(x in unique(all_detdn$Depth_band25)){
    if(length(all_detdn$Species[all_detdn$Depth_band25 == x]) >= 5){
        depths <- append(depths, x)
    }
}

all_detdn <- all_detdn[all_detdn$Depth_band25 %in% depths,]


# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(all_detdn$No_Det, "norm")
# # log normal distribution
# qqp(all_detdn$No_Det, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(all_detdn$No_Det), "Negative Binomial")
# qqp(all_detdn$No_Det, "nbinom", size = nbinom$estimate[[1]], 
#mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(all_detdn$No_Det), "Poisson")
# qqp(all_detdn$No_Det, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(all_detdn$No_Det, "gamma")
# qqp(all_detdn$No_Det, "gamma", shape = gamma$estimate[[1]], 
#rate = gamma$estimate[[2]])
# # best fit is log normal


# Linear mixed models 

# null model
detdn_glmm_null <- glmer(No_Det ~ 1 + (1|Transmitter.Name), data = all_detdn, 
family = gaussian(link = "log"))
# summary(detdn_glmm_null)
detdn_lm_null <- lm(log(No_Det) ~ 1, data = all_detdn)


# single variable models
detdn_glmm_sx <- glmer(No_Det ~ Sex + (1|Transmitter.Name), data = all_detdn, 
family = gaussian(link = "log"))
# summary(detdn_glmm_sx)
# anova(detdn_glmm_null, detdn_glmm_sx)

detdn_glmm_dn <- glmer(No_Det ~ daynight + (1|Transmitter.Name), data = all_detdn, 
family = gaussian(link = "log"))
# summary(detdn_glmm_dn)
# r.squaredGLMM(detdn_glmm_dn)
# anova(detdn_glmm_null, detdn_glmm_dn)

detdn_glmm_sp <- glmer(No_Det ~ Species + (1|Transmitter.Name), data = all_detdn, 
family = gaussian(link = "log"))
# summary(detdn_glmm_sp)
# anova(detdn_glmm_null, detdn_glmm_sp)

detdn_glmm_dep <- glmer(No_Det ~ as.factor(Depth_band25) + (1|Transmitter.Name), 
data = all_detdn, family = gaussian(link = "log"))
# summary(detdn_glmm_dep)
# anova(detdn_glmm_null, detdn_glmm_dep)

detdn_glmm_dndp <- glmer(No_Det ~ daynight + (1|Depth_band25) + (1|Transmitter.Name),
 data = all_detdn, family = gaussian(link = "log"))
# summary(detdn_glmm_dndp)
# anova(detdn_glmm_null, detdn_glmm_dndp)


detdn_aic <- AIC(detdn_glmm_null, detdn_lm_null, detdn_glmm_sx, detdn_glmm_dn, 
detdn_glmm_sp, detdn_glmm_dep, detdn_glmm_dndp)

# ### Model prediction - variation in number of detections over each depth

# # generate test data
# n <- c(as.character(factor_mode(all_detdn$Transmitter.Name)), 
#                      as.character(factor_mode(all_detdn$Date)),
#                      as.character(factor_mode(all_detdn$Sex)),
#                      as.character(factor_mode(all_detdn$daynight)),
#                      as.character(factor_mode(all_detdn$Species)),
#                      mean(all_detdn$No_Det),
#                      as.character(factor_mode(all_detdn$Migratory.Status)))

# all_detdn_newdata <- data.frame(cbind(rbind(n,n,n,n,n,n), unique(all_detdn$Depth_band25)))
# colnames(all_detdn_newdata) <- c("Transmitter.Name","Date","Sex","daynight","Species",
#                                 "No_Det","Migratory.Status","Depth_band25")

# # predicted model values
# PI <- predictInterval(detdn_glmm_dep, newdata = all_detdn_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# all_detdn_pred <- cbind(all_detdn_newdata, PI)
# all_detdn_pred$Depth_band25 <- factor(all_detdn_pred$Depth_band25, levels = c("25","50", "75", "100", "125","150","175"))

# # plot of depth trend
# detdn_plot_dep <- ggplot(all_detdn, aes(as.factor(Depth_band25), log(No_Det))) + geom_boxplot() + theme_bw() 

# detdn_plot_depdn <- ggplot(all_detdn, aes(as.factor(Depth_band25), log(No_Det), fill = daynight)) + geom_boxplot() + theme_bw() 

# detdn_plot_dn <- ggplot(all_detdn, aes(daynight, log(No_Det), fill = as.factor(Depth_band25))) + geom_boxplot() + theme_bw() 

# # depths with model values            
# ggplot(all_detdn, aes(as.numeric(as.character(Depth_band25)), log(No_Det))) + geom_point() +
#             theme_bw() + ylab("No Detections") + xlab("Depth (m)") +
#             geom_line(data = all_detdn_pred, aes(y = log(fit)), colour = "blue") +
#             geom_line(data = all_detdn_pred, aes(y = log(upr)), colour = "red", linetype = "dashed") +
#             geom_line(data = all_detdn_pred, aes(y = log(lwr)), colour = "red", linetype = "dashed")











# ### HIERARCHICAL CLUSTER ANALYSIS ###

# att_dus <- att[att$Species == "Dusky",]
# att_cl <- att_dus %>% dplyr::select(Transmitter.Name, Core_KUD_km2, Network_Density, Total_RI)


# ## agglomerative HC - AGNES

# # omit na values
# att_cl <- na.omit(att_cl)
# # att_cl$Transmitter.Name <- gsub("[.]","", att_cl$Transmitter.Name)

# all_cl <- data.matrix(att_cl[2:4])
# rownames(all_cl) <- att_cl$Transmitter.Name


# # clustering using hclust:

# # calculate dis. matrix
# d <- dist(all_cl, method = "euclidean")
# hc_KUD1 <- hclust(d, method = "complete")
# plot(hc_KUD1, cex = 0.6, hang = -1)


# # clustering using agnes:

# # look for most suitable clustering method
# m <- c("average","single","complete","ward")
# names(m) <- c("average","single","complete","ward")

# # compute coef for each method
# ac <- function(x){
#     agnes(all_cl, method = x)$ac
# }

# # assess strongest clustering method
# map_dbl(m, ac)

# # in this case is ward
# hc_KUD2 <- agnes(all_cl, method = "ward")
# # plot the tree for ward method
# pltree(hc_KUD2, cex = 0.6)


# # Divisive Hierarchial Clustering - DIANA
# hc_KUD3 <- diana(all_cl)
# # clustering coef:
# hc_KUD3$dc
# # plot dendogram
# pltree(hc_KUD3, cex = 0.6)

# # Ward's method
# hc_KUD4 <- hclust(d, method = "ward.D2")
# # cut into groups
# sub_grp <- cutree(hc_KUD4, k=2)
# # can output subgroup using table
# # plot of dendogram with clusters
# plot(hc_KUD4, cex = 0.6)
# rect.hclust(hc_KUD4, k = 2, border = 2)
# # requires more parameters ###
# fviz_cluster(list(data = all_cl, cluster = sub_grp))
# # optimal clusters
# fviz_nbclust(all_cl, FUN = hcut, method = "wss")









##### DETECTION RATE MODELS FOR 10M DEPTH BAND - ALL #####

# # subset detections for all
# dus_det10 <- subset(det10, Species == "all")
# dus_det10 <- dus_det10[dus_det10$Sex != "U",]
# dus_det10 <- dus_det10[!is.na(dus_det10$Migratory.Status),]
# codes <- c()
# for(x in unique(dus_det10$Transmitter.Name)){
#     if(length(unique(dus_det10$Date[dus_det10$Transmitter.Name == x])) >= 5){
#         codes <- append(codes, x)
#     }
# }
# dus_det10 <- dus_det10[dus_det10$Transmitter.Name %in% codes,]
# dus_det10$Season <- factor(dus_det10$Season, levels = c("Summer","Autumn", "Winter", "Spring"))

# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(dus_det10$No_Det, "norm")
# # log normal distribution
# qqp(dus_det10$No_Det, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(dus_det10$No_Det), "Negative Binomial")
# qqp(dus_det10$No_Det, "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(dus_det10$No_Det), "Poisson")
# qqp(dus_det10$No_Det, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(dus_det10$No_Det, "gamma")
# qqp(dus_det10$No_Det, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
# # best fit is log normal


# # data exploration - graphs

# # plot of individual effect on MCP
# det10_ind_boxplot <- ggplot(dus_det10[!is.na(dus_det10$No_Det),], aes(x = Transmitter.Name, y = No_Det, fill = Migratory.Status)) + 
#                     geom_boxplot()

# det10_dep_boxplot <- ggplot(dus_det10[!is.na(dus_det10$No_Det),], aes(x = Transmitter.Name, y = No_Det, fill = as.factor(Depth_band10))) + 
#                     geom_boxplot()

# # lots of detections around 60-90 depth bands
# dus_det10_sub <- subset(dus_det10, Depth_band10 < 100 & Depth_band10 > 50)
# det10_depsub_boxplot <- ggplot(dus_det10_sub[!is.na(dus_det10_sub$No_Det),], aes(x = Transmitter.Name, y = No_Det, fill = as.factor(Depth_band10))) + 
#                     geom_boxplot()


# # density plots
# det10_density_season_plot <- ggplot(dus_det10, aes(x = No_Det)) + geom_density() + facet_wrap("Season")
# det10_density_sexseason_plot <- ggplot(dus_det10, aes(x = No_Det)) + geom_density() + facet_wrap(Season ~ Sex)
# det10_density_migseason_plot <- ggplot(dus_det10, aes(x = No_Det)) + geom_density() + facet_wrap(Season ~ Migratory.Status)
# det10_density_sexmig_plot <- ggplot(dus_det10, aes(x = No_Det)) + geom_density() + facet_wrap(Migratory.Status ~ Sex)
# det10_density_all_plot <- ggplot(dus_det10, aes(x = No_Det)) + geom_density() + facet_wrap(Season ~ Migratory.Status + Sex)


# # Linear mixed models 

# # null model
# det10_glmm_null <- glmer(No_Det ~ 1 + (1|Transmitter.Name), data = dus_det10, family = gaussian(link = "log"))
# # summary(det10_glmm_null)

# # single variable models
# det10_glmm_sx <- glmer(No_Det ~ Sex + (1|Transmitter.Name), data = dus_det10, family = gaussian(link = "log"))
# # summary(det10_glmm_sx)

# det10_glmm_se <- glmer(No_Det ~ Season + (1|Transmitter.Name), data = dus_det10, family = gaussian(link = "log"))
# # summary(det10_glmm_se)

# det10_glmm_mig <- glmer(No_Det ~ Migratory.Status + (1|Transmitter.Name), data = dus_det10, family = gaussian(link = "log"))
# # summary(det10_glmm_mig)

# det10_glmm_dep <- glmer(No_Det ~ as.factor(Depth_band10) + (1|Transmitter.Name), data = dus_det10, family = gaussian(link = "log"))
# # summary(det10_glmm_dep)
# coef(det10_glmm_dep)

# # comparison of single variable models
# # anova(det10_glmm_null, det10_glmm_sx, det10_glmm_se, det10_glmm_mig, det10_glmm_dep)

# # two variable models - building on sig of depth
# det10_glmm_depsx <- glmer(No_Det ~ as.factor(Depth_band10) + Sex + (1|Transmitter.Name), data = dus_det10, family = gaussian(link = "log"))
# # summary(det10_glmm_depsx)

# det10_glmm_depse <- glmer(No_Det ~ as.factor(Depth_band10) + Season + (1|Transmitter.Name), data = dus_det10, family = gaussian(link = "log"))
# # summary(det10_glmm_depse)

# det10_glmm_depmig <- glmer(No_Det ~ as.factor(Depth_band10) + Migratory.Status + (1|Transmitter.Name), data = dus_det10, family = gaussian(link = "log"))
# # summary(det10_glmm_depmig)

# # anova(det10_glmm_null,det10_glmm_dep,det10_glmm_depmig,det10_glmm_depse,det10_glmm_depsx)




##### DETECTION RATE MODELS FOR 50M DEPTH BAND - ALL #####

# dus_det50 <- subset(det50, Species == "Dusky")
# dus_det50 <- dus_det50[dus_det50$Sex != "U",]
# dus_det50 <- dus_det50[!is.na(dus_det50$Migratory.Status),]
# codes <- c()
# for(x in unique(dus_det50$Transmitter.Name)){
#     if(length(unique(dus_det50$Date[dus_det50$Transmitter.Name == x])) >= 5){
#         codes <- append(codes, x)
#     }
# }
# dus_det50 <- dus_det50[dus_det50$Transmitter.Name %in% codes,]
# dus_det50$Season <- factor(dus_det50$Season, levels = c("Summer","Autumn", "Winter", "Spring"))


# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(dus_det50$No_Det, "norm")
# # log normal distribution
# qqp(dus_det50$No_Det, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(dus_det50$No_Det), "Negative Binomial")
# qqp(dus_det50$No_Det, "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(dus_det50$No_Det), "Poisson")
# qqp(dus_det50$No_Det, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(dus_det50$No_Det, "gamma")
# qqp(dus_det50$No_Det, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
# # best fit is log normal


# # data exploration - graphs

# # individual depth bands
# det50_dep_boxplot <- ggplot(dus_det50[!is.na(dus_det50$No_Det),], aes(x = Transmitter.Name, y = No_Det, fill = as.factor(Depth_band50))) + 
#                     geom_boxplot()



# # density plots
# det50_density_season_plot <- ggplot(dus_det50, aes(x = No_Det)) + geom_density() + facet_wrap("Season")
# det50_density_sexseason_plot <- ggplot(dus_det50, aes(x = No_Det)) + geom_density() + facet_wrap(Season ~ Sex)
# det50_density_migseason_plot <- ggplot(dus_det50, aes(x = No_Det)) + geom_density() + facet_wrap(Season ~ Migratory.Status)
# det50_density_sexmig_plot <- ggplot(dus_det50, aes(x = No_Det)) + geom_density() + facet_wrap(Migratory.Status ~ Sex)
# det50_density_all_plot <- ggplot(dus_det50, aes(x = No_Det)) + geom_density() + facet_wrap(Season ~ Migratory.Status + Sex)


# # Linear mixed models 

# # null model
# det50_glmm_null <- glmer(No_Det ~ 1 + (1|Transmitter.Name), data = dus_det50, family = gaussian(link = "log"))
# # summary(det50_glmm_null)

# # single variable models
# det50_glmm_sx <- glmer(No_Det ~ Sex + (1|Transmitter.Name), data = dus_det50, family = gaussian(link = "log"))
# # summary(det50_glmm_sx)

# det50_glmm_se <- glmer(No_Det ~ Season + (1|Transmitter.Name), data = dus_det50, family = gaussian(link = "log"))
# # summary(det50_glmm_se)
# coef(det50_glmm_se)

# det50_glmm_mig <- glmer(No_Det ~ Migratory.Status + (1|Transmitter.Name), data = dus_det50, family = gaussian(link = "log"))
# # summary(det50_glmm_mig)

# det50_glmm_dep <- glmer(No_Det ~ as.factor(Depth_band50) + (1|Transmitter.Name), data = dus_det50, family = gaussian(link = "log"))
# # summary(det50_glmm_dep)
# coef(det50_glmm_dep)

# # comparison of single variable models
# # anova(det50_glmm_null, det50_glmm_sx, det50_glmm_se, det50_glmm_mig, det50_glmm_dep)

# # two variable models - building on sig of depth
# det50_glmm_depsx <- glmer(No_Det ~ as.factor(Depth_band50) + Sex + (1|Transmitter.Name), data = dus_det50, family = gaussian(link = "log"))
# # summary(det50_glmm_depsx)

# det50_glmm_depse <- glmer(No_Det ~ as.factor(Depth_band50) + Season + (1|Transmitter.Name), data = dus_det50, family = gaussian(link = "log"))
# # summary(det50_glmm_depse)

# det50_glmm_depmig <- glmer(No_Det ~ as.factor(Depth_band50) + Migratory.Status + (1|Transmitter.Name), data = dus_det50, family = gaussian(link = "log"))
# # summary(det50_glmm_depmig)

# # anova(det50_glmm_null,det50_glmm_dep,det50_glmm_depmig,det50_glmm_depse,det50_glmm_depsx)


##### DETECTION RATE MODELS FOR DEPTHS - ALL #####

# det_all <- det
# # remove seasons to test
# det_all <- det_all[det_all$Sex != "U",]

# codes <- c()
# for(x in unique(det_all$Transmitter.Name)){
#     if(length(unique(det_all$Date[det_all$Transmitter.Name == x])) >= 5){
#         codes <- append(codes, x)
#     }
# }

# det_all <- det_all[det_all$Transmitter.Name %in% codes,]
# det_all$Season <- factor(det_all$Season, levels = c("Summer","Autumn", "Winter", "Spring"))

# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(det_all$No_Det, "norm")
# # log normal distribution
# qqp(det_all$No_Det, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(det_all$No_Det), "Negative Binomial")
# qqp(det_all$No_Det, "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(det_all$No_Det), "Poisson")
# qqp(det_all$No_Det, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(det_all$No_Det, "gamma")
# qqp(det_all$No_Det, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
# # best fit is log normal


# # Linear mixed models 

# # null model
# det_glmm_null <- glmer(No_Det ~ 1 + (1|Transmitter.Name), data = det_all, family = gaussian(link = "log"))
# # summary(det_glmm_null)
# det_lm_null <- lm(log(No_Det) ~ 1, data = det_all)

# # single variable models
# det_glmm_sx <- glmer(No_Det ~ Sex + (1|Transmitter.Name), data = det_all, family = gaussian(link = "log"))
# # summary(det_glmm_sx)
# # anova(det_glmm_null, det_glmm_sx)

# det_glmm_se <- glmer(No_Det ~ Season + (1|Transmitter.Name), data = det_all, family = gaussian(link = "log"))
# # summary(det_glmm_se)
# coef(det_glmm_se)

# det_glmm_dep <- glmer(No_Det ~ Depth + (1|Transmitter.Name), data = det_all, family = gaussian(link = "log"))
# # summary(det_glmm_dep)
# coef(det_glmm_dep)

# # comparison of single variable models
# # anova(det_glmm_null, det_glmm_sx, det_glmm_se, det_glmm_dep)

# # two variable models
# # most sig factors
# det_glmm_depse <- glmer(No_Det ~ Depth + Season + (1|Transmitter.Name), data = det_all, family = gaussian(link = "log"))
# # summary(det_glmm_depse)

# det_glmm_depsx <- glmer(No_Det ~ as.factor(Depth) + Sex + (1|Transmitter.Name), data = det_all, family = gaussian(link = "log"))
# # summary(det_glmm_depsx)

# det_glmm_depmig <- glmer(No_Det ~ as.factor(Depth) + Migratory.Status + (1|Transmitter.Name), data = det_all, family = gaussian(link = "log"))
# # summary(det_glmm_depmig)

# det_glmm_depss <- glmer(No_Det ~ as.factor(Depth) + Season + Sex + (1|Transmitter.Name), data = det_all, family = gaussian(link = "log"))
# # summary(det_glmm_depss)


# # anova(det_glmm_null,det_glmm_se, det_glmm_dep,det_glmm_depmig,det_glmm_depse,det_glmm_depsx, det_glmm_depss)






##### MOVEMENT RATE MODELS - ALL #####

# dus_mov <- subset(mov, Species == "Dusky")
# dus_mov <- dus_mov[dus_mov$Sex != "U",]
# dus_mov <- dus_mov[!is.na(dus_mov$Migratory.Status),]
# dus_mov$Season <- factor(dus_mov$Season, levels = c("Summer","Autumn", "Winter", "Spring"))





# # deciding distribution for model
# par(mfrow = c(2,3))
# # normal distribution
# qqp(dus_mov$No_Movs, "norm")
# # log normal distribution
# qqp(dus_mov$No_Movs, "lnorm")
# # negative binomial
# # generates required parameter estimates
# nbinom <- fitdistr(round(dus_mov$No_Movs), "Negative Binomial")
# qqp(dus_mov$No_Movs, "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
# # poisson
# poisson <- fitdistr(round(dus_mov$No_Movs), "Poisson")
# qqp(dus_mov$No_Movs, "pois", lambda = poisson$estimate)
# # gamma
# gamma <- fitdistr(dus_mov$No_Movs, "gamma")
# qqp(dus_mov$No_Movs, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
# # best fit is log normal


# # data exploration - graphs

# # plot of individual effect on MCP
# mov_ind_boxplot <- ggplot(dus_mov[!is.na(dus_mov$No_Movs),], aes(x = Transmitter.Name, y = No_Movs, fill = Migratory.Status)) + 
#                     geom_boxplot()



# # density plots
# mov_density_season_plot <- ggplot(dus_mov, aes(x = No_Movs)) + geom_density() + facet_wrap("Season")
# mov_density_sexseason_plot <- ggplot(dus_mov, aes(x = No_Movs)) + geom_density() + facet_wrap(Season ~ Sex)
# mov_density_migseason_plot <- ggplot(dus_mov, aes(x = No_Movs)) + geom_density() + facet_wrap(Season ~ Migratory.Status)
# mov_density_sexmig_plot <- ggplot(dus_mov, aes(x = No_Movs)) + geom_density() + facet_wrap(Migratory.Status ~ Sex)
# mov_density_all_plot <- ggplot(dus_mov, aes(x = No_Movs)) + geom_density() + facet_wrap(Season ~ Migratory.Status + Sex)


# # Linear mixed models 

# # null model
# mov_glmm_null <- glmer(No_Movs ~ 1 + (1|Transmitter.Name), data = dus_mov, family = gaussian(link = "log"))
# # summary(mov_glmm_null)

# # single variable models
# mov_glmm_sx <- glmer(No_Movs ~ Sex + (1|Transmitter.Name), data = dus_mov, family = gaussian(link = "log"))
# # summary(mov_glmm_sx)

# mov_glmm_se <- glmer(No_Movs ~ Season + (1|Transmitter.Name), data = dus_mov, family = gaussian(link = "log"))
# # summary(mov_glmm_se)
# coef(mov_glmm_se)


# ### variation in number of movements over seasons

# # generate test data
# n <- c(as.character(factor_mode(dus_mov$Transmitter.Name)), 
#                      as.character(factor_mode(dus_mov$Date)),
#                      as.character(factor_mode(dus_mov$Sex)),
#                      as.character(factor_mode(dus_mov$Species)),
#                      mean(dus_mov$No_Movs),
#                      as.character(factor_mode(dus_mov$Migratory.Status)))

# dus_mov_newdata <- data.frame(cbind(rbind(n,n,n,n), as.character(unique(dus_mov$Season))))
# colnames(dus_mov_newdata) <- c("Transmitter.Name","Date","Sex","Species",
#                                 "No_Movs","Migratory.Status","Season")

# # predicted model values
# PI <- predictInterval(mov_glmm_se, newdata = dus_mov_newdata, level = 0.95,
#                         n.sims = 1000, stat = "median", type = "probability", include.resid.var = TRUE)
# # joined with sample dataset
# dus_mov_pred <- cbind(dus_mov_newdata, PI)
# dus_mov_pred$Season <- factor(dus_mov_pred$Season, levels = c("Summer","Autumn", "Winter", "Spring"))

# # plot of seasonal trend
# ggplot(dus_mov, aes(Season, log(No_Movs), fill = Sex)) + geom_boxplot() + 
#             #geom_line(data = dus_mov_pred, aes(as.numeric(Season), fit)) +
#             theme_bw() + ylab("Movements") + xlab("Season")
# ggplot(dus_mov, aes(Season, log(No_Movs))) + geom_boxplot() + 
#             geom_line(data = dus_mov_pred, aes(as.numeric(Season), log(fit))) +
#             theme_bw() + ylab("No Detections") + xlab("Season")





# mov_glmm_mig <- glmer(No_Movs ~ Migratory.Status + (1|Transmitter.Name), data = dus_mov, family = gaussian(link = "log"))
# # summary(mov_glmm_mig)

# mov_glmm_semig <- glmer(No_Movs ~ Season + Migratory.Status + (1|Transmitter.Name), data = dus_mov, family = gaussian(link = "log"))
# # summary(mov_glmm_semig)

# mov_glmm_sesx <- glmer(No_Movs ~ Season + Sex + (1|Transmitter.Name), data = dus_mov, family = gaussian(link = "log"))
# # summary(mov_glmm_sesx)

# # comparison of additions
# # anova(mov_glmm_null, mov_glmm_se, mov_glmm_mig, mov_glmm_semig, mov_glmm_sesx)












# # subset for years
# year_names <- c("2011", "2012", "2013","2014","2015","2016","2017","2018")
# year_data <- data.frame()
# for(x in year_names){
#     a <- att %>% dplyr::select(Transmitter.Name, Species, Sex, FL, Migratory.Status, 
#                     paste0("MCP_area_",x), paste0("core_KUD_",x), 
#                     paste0("Network_Density_", x), Av_Depth_Nin)
#     colnames(a)[6:8] <- c("MCP_area","core_KUD","Network_Density")
#     a$Year <- rep(x, length(a$Transmitter.Name))
#     year_data <- rbind(year_data, a)
# }

# # species subsets (split by year)
# dus_year <- subset(year_data, Species == "Dusky")
# dus_year <- dus_year[dus_year$Sex != "U",]
# dus_year <- dus_year[!is.na(dus_year$Migratory.Status),]
# san_year <- subset(year_data, Species == "Sandbar")












