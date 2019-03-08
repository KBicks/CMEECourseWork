#!/usr/bin/env Rscript
# Author: Katie Bickerton k.bickerton18@imperial.ac.uk
# Script: model_fitting.R
# Desc: Builds models for pred_prey dataset, fits models using appropriate 
# methods for each model, plots models and compares models using the Akaike 
# information criterion. 
# Arguments: none
# Date: 28 Feb 2019

# clear workspace
rm(list=ls())
graphics.off()


# reading in dataframe
p <- read.csv("../Data/pred_prey_wrangled.csv", header=TRUE, na.strings=c("","NA"))


###### MODEL 1: Linear Regression Model ######

# defining initial version of the linear model with all possible explanatory variables
# (excluded habitat and feeding interaction as non indepedent of possible explanatory variables)

lin_mod1 <- lm(log(pred_meanmass) ~ prey_meanmass + temp_mean + depth_mean, data = p)

# summarises plot giving relative coefficients for each variable
lm1sum <- summary(lin_mod1)
# analyses variance of the model
lm1an <- anova(lin_mod1)
# steps back the model, calculating AIC, then dropping the highest value, then continuing, to find the best fit to the data
# used in analysis but always outputs even when set to a variable so commented out for main script
# step(lin_mod1)

# same process as above but using log transforms as not all variables are normally distributed
lin_mod2 <- lm(log(pred_meanmass) ~ log(prey_meanmass) + temp_mean + log(depth_mean), data = p)
lm2sum <- summary(lin_mod2)
lm2an <- anova(lin_mod2)
# lm2step <- step(lin_mod2)

# AIC value smaller for the log tranformed model - therefore better fit
aic_lm1vslm2 <- AIC(lin_mod1) - AIC(lin_mod2)

# linear regressio model: predator mass ~ prey mass + epsilon
lin_mod <- lm(log(pred_meanmass) ~ log(prey_meanmass), data = p)

# checking assumptions with linear model fit plots - commented out for bash script
# par(mfrow=c(2,2))
# plot(lin_mod)



###### MODEL 2: Generalised Additive Model ######

require(mgcv)

# gaussian generalised additive model with all independent variables, log transformed as linear model logs the response variable
# alternative models with and without log transforms, dropping least significant variable in each case (equivalent of lm step function)
# 3 explanatory variable models
gam_mod1 <- gam(log(pred_meanmass) ~ s(prey_meanmass) + s(temp_mean) + s(depth_mean), data = p, family = gaussian(), method="REML")
gm1sum <- summary(gam_mod1)
gm1an <- anova(gam_mod1)
gam_mod2 <- gam(log(pred_meanmass) ~ s(log(prey_meanmass)) + s(temp_mean) + s(depth_mean), data = p, family = gaussian(), method="REML")
gm2an <- anova(gam_mod2)
gam_mod3 <- gam(log(pred_meanmass) ~ s(log(prey_meanmass)) + s(temp_mean) + s(log(depth_mean)), data = p, family = gaussian(), method="REML")
gm3an <- anova(gam_mod3)

# 2 explanatory variables
gam_mod4 <- gam(log(pred_meanmass) ~ s(prey_meanmass) + s(temp_mean), data = p, family = gaussian(), method="REML")
gm4an <- anova(gam_mod4)
gam_mod5 <- gam(log(pred_meanmass) ~ s(log(prey_meanmass)) + s(depth_mean), data = p, family = gaussian(), method="REML")
gm5an <- anova(gam_mod5)
gam_mod6 <- gam(log(pred_meanmass) ~ s(log(prey_meanmass)) + s(log(depth_mean)), data = p, family = gaussian(), method="REML")
gm6an <- anova(gam_mod6)

# 1 explanatory variable
gam_mod7 <- gam(log(pred_meanmass) ~ s(prey_meanmass), data = p, family = gaussian(), method="REML")
gam_mod8 <- gam(log(pred_meanmass) ~ s(log(prey_meanmass)), data = p, family = gaussian(), method="REML")

# compare models using AIC values
AIC_gam_models <- c(AIC(gam_mod1, gam_mod2, gam_mod3, gam_mod4, gam_mod5, gam_mod6, gam_mod7, gam_mod8))
gam_models <- c("model1", "model2", "model3", "model4", "model5", "model6","model7","model8")
AIC_gam <- data.frame(gam_models, AIC_gam_models)

# gives optimal GAM model = model 2
optimal_gam <- AIC_gam$gam_models[AIC_gam$AIC == min(AIC_gam$AIC)]

# optimal GAM model for comparison
gam_mod <- gam(log(pred_meanmass) ~ s(log(prey_meanmass)) + s(temp_mean) + s(depth_mean), data = p, family = gaussian(), method="REML")

# GAM model fit plots - commented out for bash script
# gam.check(gam_mod)





###### MODEL 3: Linear Mixed Effects Model ######

require(lme4)

# construct first fixed model starting with all variable - non normal logged, habitat and feeding interaction as random
glmm_mod1 <- lmer(log(pred_meanmass)~ log(prey_meanmass) + temp_mean + log(depth_mean) + (1|habitat) + (1|feeding_interaction), data = p)
glmm1sum <- summary(glmm_mod1)
# second model excludes temperature, and finds no significant difference between models so temperature can be dropped
glmm_mod2 <- lmer(log(pred_meanmass)~log(prey_meanmass) + log(depth_mean) + (1|habitat) + (1|feeding_interaction), data = p)
glmm2sum <- summary(glmm_mod2) 
glmman12 <- anova(glmm_mod1, glmm_mod2)

# comparison to second model dropping least significant fixed effect
glmm_mod3 <- lmer(log(pred_meanmass)~log(prey_meanmass) + (1|habitat) + (1|feeding_interaction), data = p)
glmm3sum <- summary(glmm_mod3)
glmman23 <- anova(glmm_mod2,glmm_mod3)
# comparison to second model dropping least significant random effect
glmm_mod4 <- lmer(log(pred_meanmass)~log(prey_meanmass) + log(depth_mean) + (1|feeding_interaction), data = p)
glmm4sum <- summary(glmm_mod4)
glmman24 <- anova(glmm_mod2, glmm_mod4)
# comparison to second model dropping other random effect
glmm_mod5 <- lmer(log(pred_meanmass)~log(prey_meanmass) + log(depth_mean) + (1|habitat), data = p)
glmm5sum <- summary(glmm_mod3)
glmman25 <- anova(glmm_mod2, glmm_mod5)


# greatest reduction in AIC by removing depth, negligable difference removing random factors
# compare difference between model with two each random factor
glmm_mod6 <- lmer(log(pred_meanmass)~log(prey_meanmass) + (1|habitat), data = p)
glmm_mod7 <- lmer(log(pred_meanmass)~log(prey_meanmass) + (1|feeding_interaction), data = p)
glmm6sum <- summary(glmm_mod6)
glmm7sum <- summary(glmm_mod7)
glmman67 <- anova(glmm_mod6, glmm_mod7)
# comparing model without habitat random effect to model with both random effects
glmman37 <- anova(glmm_mod3,glmm_mod7)

# compare models using AIC values
AIC_glmm_models <- c(AIC(glmm_mod1, glmm_mod2, glmm_mod3, glmm_mod4, glmm_mod5, glmm_mod6, glmm_mod7))
glmm_models <- c("model1", "model2", "model3", "model4", "model5", "model6","model7")
AIC_glmm <- data.frame(glmm_models, AIC_glmm_models)

# gives optimal glmm model = model 7
optimal_glmm <- AIC_glmm$glmm_models[AIC_glmm$AIC == min(AIC_glmm$AIC)]

# best fitting glmm:
glmm_mod <- lmer(log(pred_meanmass)~log(prey_meanmass) + (1|feeding_interaction), data = p)



###### FINAL MODEL SELECTION ######

# comparing final AIC values of models to give best fit to data
AIC_final_models <- c(AIC(lin_mod, gam_mod, glmm_mod))
final_models <- c("LM", "GAM", "GLMM")
AIC_final <- data.frame(final_models, AIC_final_models)

# gives optimal glmm model = model 7
optimal_model_final <- AIC_final$final_models[AIC_final$AIC == min(AIC_final$AIC)]




###### PLOTS FOR REPORT ######

require(ggplot2)

# Plotting linear model and used to explain glmm results
p1 <-  ggplot(p, aes(x = log(prey_meanmass), y = log(pred_meanmass), colour = feeding_interaction, ylab = "Log Predator Mass")) + 
    geom_point(size=2) + 
    geom_abline(intercept = lin_mod$coefficients[1][1], slope = lin_mod$coefficients[2][1],  colour = "black") +
    theme_bw() +
    labs(x = "Log Prey Mass", y = "Log Predator Mass", colour = "Feeding Interaction")

# save plot as a pdf
pdf("../Results/lin_mod_feeding.pdf", width = 6, height = 6)
print(p1)
dev.off()


p2 <- qplot(log(pred_meanmass), data = p, geom = "density", fill = feeding_interaction, alpha = I(0.5), xlab="Log Predator Mass", ylab = "Density") + 
    theme_bw() + theme(legend.position = "none")

# save plot as a pdf
pdf("../Results/density_feeding.pdf", width = 6, height = 6)
print(p2)
dev.off()

# Residuals Plots

# Linear Model residual plot
p3 <- ggplot(aes(x = log(pred_meanmass), y=resid(lin_mod)), data = p) + geom_point() + theme_bw() +
    labs(y = "Residuals", x = "Log Predator Mass") + ylim(-4,6)

# GAM model residual plot
p4 <- ggplot(aes(x = log(pred_meanmass), y=resid(gam_mod)), data = p) + geom_point() + theme_bw() +
    labs(y = "Residuals", x = "Log Predator Mass") + ylim(-4,6)

# GLMM model residual plot
p5 <- ggplot(aes(x = log(pred_meanmass), y=resid(glmm_mod)), data = p) + geom_point() + theme_bw() +
    labs(y = "Residuals", x = "Log Predator Mass") + ylim(-4,6)

# save plot as a pdf
pdf("../Results/lin_mod_resid.pdf", width = 6, height=3)
print(p3)
dev.off()

# save plot as a pdf
pdf("../Results/gam_mod_resid.pdf", width = 6, height=3)
print(p4)
dev.off()

# save plot as a pdf
pdf("../Results/glmm_mod_resid.pdf", width = 6, height=3)
print(p5)
dev.off()


# Plotting GAM models

# save plot as a pdf
pdf("../Results/gam_mod_plot.pdf",width=7, height = 10)
par(mfrow = c(3,1))
plot(gam_mod)
dev.off()
