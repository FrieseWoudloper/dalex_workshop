rm(list = ls())

# Imputed titanic dataset copied from github.com/pbiecek/models/gallery
load(file.path("data", "27e5c637a56f3e5180d7808b2b68d436.rda"))

johnny_d <- titanic[0, c(-5, -9)]
johnny_d[1, ] <- list(gender = "male", age = 8, class = "1st",
                      embarked = "Southampton", fare = 72,
                      sibsp = 0, parch = 0)

henry <- titanic[0, c(-5, -9)]
henry[1, ] <- list(gender = "male", age = 47, class = "1st",
                   embarked = "Cherbourg", fare = 25,
                   sibsp = 0, parch = 0)

titanic_lrm <- rms::lrm(survived == "yes" ~ class + gender + rms::rcs(age) +
                                sibsp + parch + fare + embarked,
                        data = titanic)

set.seed(1313)
titanic_rf <- randomForest::randomForest(survived ~ class + gender + age +
                                                 sibsp + parch + fare + embarked,
                                         data = titanic)

set.seed(1313)
titanic_gbm <- gbm::gbm(survived == "yes" ~ class + gender + age + sibsp +
                                parch + fare + embarked,
                        data = titanic,
                        n.trees = 15000,
                        distribution = "bernoulli")

set.seed(1313)
titanic_svm <- e1071::svm(survived == "yes" ~ class + gender + age + sibsp +
                                  parch + fare + embarked,
                          data = titanic,
                          type = "C-classification",
                          probability = TRUE)

titanic_lrm_exp <- DALEX::explain(titanic_lrm,
                                  data = titanic[, -9],
                                  y = titanic$survived == "yes",
                                  label = "Logistic Regression",
                                  type = "classification",
                                  verbose = FALSE)

titanic_rf_exp <- DALEX::explain(model = titanic_rf,
                                 data = titanic[, -9],
                                 y = titanic$survived == "yes",
                                 label = "Random Forest",
                                 verbose = FALSE)

titanic_gbm_exp <- DALEX::explain(model = titanic_gbm,
                                  data = titanic[, -9],
                                  y = titanic$survived == "yes",
                                  label = "Generalized Boosted Regression",
                                  verbose = FALSE)

titanic_svm_exp <- DALEX::explain(model = titanic_svm,
                                  data = titanic[, -9],
                                  y = titanic$survived == "yes",
                                  label = "Support Vector Machine",
                                  verbose = FALSE)

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
     titanic_lrm_exp,
     titanic_rf_exp,
     titanic_gbm_exp,
     titanic_svm_exp,
     file = file.path("inst", "extdata", "objects.Rdata"))

rm(list = ls())
