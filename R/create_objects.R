library(learnr)
library(archivist)
library(DALEX)
library(rms)
library(randomForest)
library(gbm)
library(e1071)

# Data
titanic <- titanic_imputed
titanic$survived[titanic$survived == 0] <- "no"
titanic$survived[titanic$survived == 1] <- "yes"
titanic$survived <- as.factor(titanic$survived)
johnny_d <- data.frame(
  class = factor("1st",
                 levels = c("1st", "2nd", "3rd", "deck crew",
                            "engineering crew", "restaurant staff",
                            "victualling crew")),
  gender = factor("male",
                  levels = c("female", "male")),
  age = 8,
  sibsp = 0,
  parch = 0,
  fare = 72,
  embarked = factor("Southampton",
                    levels = c("Belfast","Cherbourg",
                               "Queenstown","Southampton")))
henry <- data.frame(
  class = factor("1st",
                 levels = c("1st", "2nd", "3rd",
                            "deck crew", "engineering crew",
                            "restaurant staff", "victualling crew")),
  gender = factor("male",
                  levels = c("female", "male")),
  age = 47,
  sibsp = 0,
  parch = 0,
  fare = 25,
  embarked = factor("Cherbourg",
                    levels = c("Belfast", "Cherbourg","Queenstown","Southampton")))

# Train models
set.seed(1313)
titanic_lrm <- lrm(survived == "yes" ~ class + gender + rcs(age) + sibsp +
                     parch + fare + embarked, data = titanic)
titanic_rf <- randomForest(survived ~ class + gender + age + sibsp + parch +
                             fare + embarked, data = titanic)
titanic_gbm <- gbm(survived == "yes" ~ class + gender + age + sibsp + parch + fare + embarked,
                   data = titanic,
                   n.trees = 15000,
                   distribution = "bernoulli")
titanic_svm <- svm(survived == "yes" ~ class + gender + age +
                     sibsp + parch + fare + embarked, data = titanic,
                   type = "C-classification", probability = TRUE)
