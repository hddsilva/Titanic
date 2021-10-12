# Titanic

Of the 1043 Titanic passengers included in the sample, 63% were male and 37% were female. 48% were in third class, 25% were in second class, and 27% were in first class. 41% survived while 59% did not. The youngest passenger was under a year old (0.17 years) and the oldest was 80. The average age of passengers was 30 years old. A table summarizing the unadjusted and adjusted odds ratio for survival on the Titanic is below.

There was a 92% decrease in the likelihood of survival if the passenger was male, and for every 10 years older a passenger was, there was a 28% decrease in survival. Second class passengers had a 64% decreased chance of survival relative to first class passengers, and this became an 86% decrease in survival if the passenger was third class. Passengers departing from Queenstown had a 75% decreased chance of survival than those who departed from Cherbourg, compared to a 51% decrease in survival if departing from Southampton. Overall, the best predictors of survival were sex and class, with males and 3rd class passengers having the least chance of survival. 

The AIC of the final model was 980.23, which considers both the model fit and the number of parameters. The AUC of the final model 0.84. The AUC measures the discriminatory ability of the model between 0.5 (no discrimination) and 1 (perfect discrimination). An AUC of 0.84 tells us that our final model has an 84% chance of being able to correctly classify a random pair of observations from the model’s predictor variables.

Chances of survival for:
Man vs Woman – aged 30 years in 1st class who embarked from Southampton
  Man: 42%.  Woman: 90%
Man vs Woman – aged 65 years in 1st class who embarked from Southampton
  Man: 18%.  Woman: 74%





