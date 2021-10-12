

if(!require(readxl)){install.packages("readxl")}
if(!require(base)){install.packages("base")}
if(!require(psych)){install.packages("psych")}
if(!require(stats)){install.packages("stats")}
if(!require(ROCR)){install.packages("ROCR")}
if(!require(MASS)){install.packages("MASS")}



# Read, Attach, and Display Variable Names in Dataset
library(readxl)
library(dplyr)
Titanic_ALL <- read_excel("Titanic_Data.xlsx")
#View(Titanic_ALL)
#str(Titanic_ALL)
attach(Titanic_ALL)
names(Titanic_ALL)


# Exclude Missing Data for Variables of Interest & add binomial sex
Titanic <- Titanic_ALL[!(is.na(survived)) & !(is.na(age)) & !(is.na(sex)) &
                       !(is.na(pclass)) & !(is.na(parch_bin)) &
                       !(is.na(fare)) & !(is.na(embarked)),]
attach(Titanic)


# Frequency Tables
library(base)
transform(table(survived), Percent = 100*prop.table(Freq), cumFreq = cumsum(Freq))
transform(table(sex), Percent = 100*prop.table(Freq), cumFreq = cumsum(Freq))
transform(table(pclass), Percent = 100*prop.table(Freq), cumFreq = cumsum(Freq))


# Summary Measures
library(psych)
describe(age, fast = TRUE)


# Crosstabulation
cbind(addmargins(table(survived, sex), margin = 1),
      addmargins(round(100*prop.table(table(survived, sex), margin = 2),  digits = 1),  margin = 1))

# Full model - multiple logistic regression
Titanic.logit_full <- glm(data = Titanic, survived ~ sex + age + pclass + 
                            parch_bin + fare + embarked, family = "binomial")
summary(Titanic.logit_full)

# Odds Ratio
exp(cbind(OR = coef(Titanic.logit_full),
          confint(Titanic.logit_full)))

# Forward Selection
library(MASS)
Titanic.logit_intercept <- glm(data = Titanic, survived ~ 1, family = "binomial")
Titanic.logit_forward <- stepAIC(Titanic.logit_intercept, direction = "forward",
                                 scope = formula(Titanic.logit_full), trace = FALSE)
Titanic.logit_forward$anova

# Backward Elimination
Framingham.logit_backward <- stepAIC(Titanic.logit_full, direction = "backward", scope = formula(Titanic.logit_full), trace = FALSE)
Framingham.logit_backward$anova

# Final Model
Titanic.logit_final <- glm(data = Titanic, survived ~ sex + pclass + age + embarked, family = "binomial")
summary(Titanic.logit_final)
# ROC Analysis
prob = predict(Titanic.logit_final, type = "response")
ROCRpred <- prediction(prob, Titanic$survived)

ROCRperf <- performance(ROCRpred, measure = "auc")
print(ROCRperf@y.values)

ROCRperf <- performance(ROCRpred, measure = "tpr", x.measure = "fpr")
plot(ROCRperf, lwd = 2, xlab="1-Specificity", ylab="Sensitivity")
abline(0, 1, lwd = 2, lty = 2) #add a 45 degree dashed line

# Odds Ratio
exp(cbind(OR = coef(Titanic.logit_final),
          confint(Titanic.logit_final)))
exp(10*(cbind(OR = coef(Titanic.logit_final),
                  confint(Titanic.logit_final))))

# Unadjusted model - sex
Titanic.logit_sex <- glm(data = Titanic, survived ~ sex, family = "binomial")
summary(Titanic.logit_sex)
# Odds Ratio
exp(cbind(OR = coef(Titanic.logit_sex),
          confint(Titanic.logit_sex)))

# Unadjusted model - pclass
Titanic.logit_pclass <- glm(data = Titanic, survived ~ pclass, family = "binomial")
summary(Titanic.logit_pclass)
# Odds Ratio
exp(cbind(OR = coef(Titanic.logit_pclass),
          confint(Titanic.logit_pclass)))

# Unadjusted model - age
Titanic.logit_age <- glm(data = Titanic, survived ~ age, family = "binomial")
summary(Titanic.logit_age)
# Odds Ratio
exp(10*(cbind(OR = coef(Titanic.logit_age),
                  confint(Titanic.logit_age))))

# Unadjusted model - embarked
Titanic.logit_embarked <- glm(data = Titanic, survived ~ embarked, family = "binomial")
summary(Titanic.logit_embarked)
# Odds Ratio
exp(cbind(OR = coef(Titanic.logit_embarked),
          confint(Titanic.logit_embarked)))

# Predicted Risk of Survival
# Man vs Woman – aged 30 years in 1st class who embarked from Southampton
predictor_values <- with(Titanic,
                         data.frame(age = 30, sex = c("Male","Female"),
                                    pclass = "1st", embarked = "Southampton"))
predictor_values$predicted <- predict(Titanic.logit_final, newdata = predictor_values, type = "response")
predictor_values

# Predicted Risk of Survival
# Man vs Woman – aged 65 years in 1st class who embarked from Southampton;
predictor_values <- with(Titanic,
                         data.frame(age = 65, sex = c("Male","Female"),
                                    pclass = "1st", embarked = "Southampton"))
predictor_values$predicted <- predict(Titanic.logit_final, newdata = predictor_values, type = "response")
predictor_values

# Predicted Risk of Survival
# Man vs Woman – aged 65 years in 3rd class who embarked from Southampton.
predictor_values <- with(Titanic,
                         data.frame(age = 65, sex = c("Male","Female"),
                                    pclass = "3rd", embarked = "Southampton"))
predictor_values$predicted <- predict(Titanic.logit_final, newdata = predictor_values, type = "response")
predictor_values

# Predicted Risk of Survival
# 1st vs 2nd vs 3rd class – woman aged 30 years who embarked from Southampton.
predictor_values <- with(Titanic,
                         data.frame(age = 30, sex = "Female",
                                    pclass = c("1st","2nd","3rd"), embarked = "Southampton"))
predictor_values$predicted <- predict(Titanic.logit_final, newdata = predictor_values, type = "response")
predictor_values
