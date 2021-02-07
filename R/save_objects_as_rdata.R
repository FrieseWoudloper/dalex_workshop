library(archivist)
titanic  <- aread("pbiecek/models/27e5c")

johnny_d <- titanic[0, c(-5, -9)]
johnny_d[1, ] <- list(gender = "male", age = 8, class = "1st",
                      embarked = "Southampton", fare = 72,
                      sibsp = 0, parch = 0)

henry <- titanic[0, c(-5, -9)]
henry[1, ] <- list(gender = "male", age = 47, class = "1st",
                   embarked = "Cherbourg", fare = 25,
                   sibsp = 0, parch = 0)

library(rms)
titanic_lrm <- lrm(survived == "yes" ~ class + gender + rcs(age) +
                     sibsp + parch + fare + embarked, data = titanic)

library(randomForest)
set.seed(1313)
titanic_rf <- randomForest(survived ~ class + gender + age + sibsp + parch +
                             fare + embarked, data = titanic)

library(gbm)
set.seed(1313)
titanic_gbm <- gbm(survived == "yes" ~ class + gender + age + sibsp + parch +
                     fare + embarked, data = titanic, n.trees = 15000,
                     distribution = "bernoulli")

library(e1071)
set.seed(1313)
titanic_svm <- svm(survived == "yes" ~ class + gender + age + sibsp + parch +
                     fare + embarked, data = titanic, type = "C-classification",
                     probability = TRUE)

library(DALEX)
titanic_lrm_exp <- explain(titanic_lrm,
                           data = titanic[, -9],
                           y = titanic$survived == "yes",
                           label = "Logistic Regression",
                           type = "classification",
                           verbose = FALSE)

titanic_rf_exp <- explain(model = titanic_rf,
                          data = titanic[, -9],
                          y = titanic$survived == "yes",
                          label = "Random Forest",
                          verbose = FALSE)
# usethis::use_data(titanic_rf_exp, overwrite = TRUE)

titanic_gbm_exp <- explain(model = titanic_gbm,
                           data = titanic[, -9],
                           y = titanic$survived == "yes",
                           label = "Generalized Boosted Regression",
                           verbose = FALSE)
# usethis::use_data(titanic_gbm_exp, overwrite = TRUE)

titanic_svm_exp <- explain(model = titanic_svm,
                           data = titanic[, -9],
                           y = titanic$survived == "yes",
                           label = "Support Vector Machine",
                           verbose = FALSE)
# usethis::use_data(titanic_svm_exp, overwrite = TRUE)

# library(localModel)
# lime_rf <- predict_surrogate(explainer = titanic_rf_exp,
#                              new_observation = johnny_d,
#                              size = 1000,
#                              seed = 1,
#                              type = "localModel")

save(titanic,
     johnny_d,
     henry,
     titanic_lrm,
     titanic_rf,
     titanic_gbm,
     titanic_svm,
     titanic_svm_exp,
     titanic_lrm_exp,
     titanic_rf_exp,
     titanic_gbm_exp,
     titanic_svm_exp,
     file = file.path("inst", "extdata", "objects.Rdata"))
