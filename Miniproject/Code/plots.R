# values to use for prediction
prey_masses <- seq(min(p$prey_meanmass), max(p$prey_meanmass), len = 57)

# predicted values
predict_lin_mod <- predict.lm(lin_mod, data.frame(prey_meanmass = prey_masses))

# show fit of model
plot(log(p$pred_meanmass) ~ log(p$prey_meanmass))
# show fit of model - could plot either of predict models, both would work
lines(log(prey_masses),predict_lin_mod, col = "red")

# plots smoothed functions for each variable of GAM model with se dotted lines
par(mfrow=c(1,3))
plot(gam_mod, se=TRUE)

