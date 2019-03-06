rm(list=ls())
graphics.off()

# load required packages
require(dplyr)
require(ggplot2)
require(repr)
#require(minpack.lm)
#require(nlme)
#require(mgcv)

# reading in dataframe
p <- read.csv("../Data/pred_prey_wrangled.csv", header=TRUE, na.strings=c("","NA"))

# defining initial version of the linear model with all possible explanatory variables
# (excluded prey length, habitat and feeding interaction as non indepedent of possible explanatory variables)

lin_mod1 <- lm(pred_meanmass ~ prey_meanmass + temp_mean + depth_mean, data = p)

# summarises plot giving relative coefficients for each variable
lm1sum <- summary(lin_mod1)
# analyses variance of the model
lm1an <- anova(lin_mod1)
# steps back the model, calculating AIC, then dropping the highest value, then continuing, to find the best fit to the data
# used in analysis but always outputs even when set to a variable so commented out for main script
# step(lin_mod1)

# same process as above but using log transforms as not all variables are normally distributed
lin_mod2 <- lm(pred_meanmass ~ log(prey_meanmass) + temp_mean + log(depth_mean), data = p)
lm2sum <- summary(lin_mod2)
lm2an <- anova(lin_mod2)
# lm2step <- step(lin_mod2)

# use of the log transform decreased fit of the model - AIC value smaller for the non-log tranformed model
aic_lm1vslm2 <- AIC(lin_mod1) - AIC(lin_mod2)

# linear regressio model: predator mass ~ prey mass + epsilon

# function not needed this time as lm has predict function
lin_mod <- function(x,a,b) {
    y = a + b*x
    return(y)
}

# linear model format of above function
lin_mod_final <- lm(pred_meanmass ~ prey_meanmass, data = p)

# coefficients for regression equation extracted from linear model
a <- coef(lin_mod_final)[[1]]
b <- coef(lin_mod_final)[[2]]

# values to use for prediction
prey_masses <- seq(min(p$pred_meanmass), max(p$pred_meanmass), len = 57)

# generate predicted values using transferable method (also option to use predict.lm for linear models)
# both methods give the same set of results
predict_lin_mod <- lin_mod(prey_masses,a,b)
predict_lin_mod_method2 <- predict.lm(lin_mod_final, data.frame(prey_meanmass = prey_masses))

# show fit of model
plot(p$pred_meanmass ~ p$prey_meanmass)
# show fit of model - could plot either of predict models, both would work
lines(prey_masses,predict_lin_mod, col = "red")
