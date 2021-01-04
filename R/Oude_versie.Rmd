## 4 Models' explainers

In the previous step we created two models. They have different internal structures and interfaces. We need a uniform interface in order to create explanations and compare both models. For this purpose we4  create model explainer objects.

### 4.1 Explainer for the logistic regression model

We create an explainer object with the `explain()` function from the `DALEX` package. The first and required argument to the function is the model to be explained. The `data` argument specifies a data frame with features and `y` a numeric vector with true outcomes. `label` contains the name of the model. It can be anything you like.

```{r ex4, exercise = TRUE}
library(DALEX)
exp_lms <- explain(___,
                      data = train[, 1:7],
                      y = ___$survived,
                      label = "Logistic with splines")
```

```{r ex4-solution}
library(DALEX)
exp_lms <- explain(lms,
                   data = train,
                   y = train$survived,
                   label = "Logistic with splines")
```

After the explainer has been created, you can retrieve basic information about the model.

```{r ex5, exercise = TRUE}
exp_lms$model_info
```

### 4.2 Explainer for the random forest model

Now also create an explainer for the random forest model.

```{r ex6, exercise = TRUE}

exp_rf <- explain(___,
                     data = ___,
                     y = ___,
                     label = "Random forest")
```

```{r ex6-solution}
exp_rf <- explain(titanic_rf,
                  data = train[, 1:7],
                  y = train$survived,
                  label = "Random forest")
```

Extract model information from the explainer.

```{r ex7, exercise = TRUE}

```

```{r ex7-solution}
exp_rf$model_info
```

```{r q1}
l <- unlist(strsplit(exp_rf$model_info$ver, "[.]"))
create_answer <- function(){
  index <- sample(1:3, 1)
  l[index] <<- as.character(as.integer(l[index]) + 1)
  return(paste(l, collapse = "."))
}
question("What version of the <code>ranger</code> package was used to create the model?",
         answer(create_answer()),
         answer(exp_rf$model_info$ver, correct = TRUE),
         answer(create_answer()),
         answer(create_answer())
)
```

## 5 Model performance

Let us examine model performance. We can do this by calculating performance metrics with the `model_performance()` function and then visualizing them.

Of course, it is not sufficient to calculate performance metrics on the training set. You want to evaluate model performance on unseen data, also known as the test set. However, to keep this tutorial simple, we will skip that part for now.

### 5.1 Performance metrics

Extend the code below to calculate performance metrics for the logistic regression model as well as those for the random forest model.

```{r ex8, exercise = TRUE}
mp_lms <- model_performance(exp_lms)
unlist(mp_lms$measures)
```

```{r ex8-solution}
mp_lms <- model_performance(exp_lms)
unlist(mp_lms$measures)
mp_rf <- model_performance(exp_rf)
unlist(mp_rf$measures)
```

```{r q2}
question("Which model performs best on the training data?",
         answer("Logistic regression model with splines"),
         answer("Random forest model", correct = TRUE),
         answer("Both models perform equally")
)
```

### 5.2 Visualization

We can now visualize and compare model performance using the `plot` function. By providing an `geom` argument we can specify what kind of plot we want. We can choose between `"prc"`, `"roc"`, `"ecdf"`, `"boxplot"`, `"gain"`, `"lift"` and `"histogram"`.

Adjust the code below so that an _Receiver Operator Characteristic_ (ROC) curve is created, and we can visually examine the _Area Under the Curve_ (AUC).

```{r ex9, exercise = TRUE, exercise.eval = TRUE}
plot(mp_rf, mp_lms, geom = "prc")
```

```{r ex9-solution}
plot(mp_rf, mp_lms, geom = "roc")
```

## 6 Dataset level explanations

## 7 Instance level explanations

An instance level explanation answers the question why a particular prediction was made for an observation. It is an explanation for a single prediction.

### 7.1 Predictions

Let's say we want to predict whether Joe will survive the sinking of the Titanic. Joe is a 42-year-old male who embarked in Southampton and travels third class with no parents nor siblings, and with a ticket costing a little over 7 pounds. A dataframe containing Joe's characteristics has already been created for our convenience.

```{r ex10, exercise = TRUE, exercise.eval = TRUE}
joe
```

The code below returns the logistic regression model's prediction for Joe. Add a line of code so it also gives the prediction according to the random forest model.

```{r ex11, exercise = TRUE, exercise.eval = TRUE}
predict(exp_lms, joe)
```

```{r ex11-solution}
cat("Logistic regression with splines:", predict(exp_lms, joe))
cat("Random forest:", predict(exp_rf, joe))
```

```{r q3}
question("Which model predicts a slightly higher survival probability for Joe?",
  answer("Logistic regression model with splines"),
  answer("Random forest model", correct = TRUE),
  answer("Both models predict an equal survival probability")
)
```

### Break-down plot for additive attributions

Both our models predict that it is not very likely that Joe will survive the sinking of the Titanic. Which features of Joe were of most importance? One way of answering this question is by creating a _break-down plot for additive attributions_. The plot is a decomposition of a model's prediction into contributions that can be attributed to different explanatory variables.

Create a break-down plot for Joe's prediction obtained from the random forest model.

```{r ex12, exercise = TRUE, exercise.eval = TRUE}
bd_joe <- predict_parts(exp_rf, joe, type = "break_down")
plot(bd_joe)
```

The first row in the break-down plot shows the overall mean value of predictions for the entire dataset. It is an estimate of the expected value of the model’s predictions over the distribution of all explanatory variables.

The next rows present the changes in the mean prediction when fixing values of subsequent explanatory variables. They are the contributions attributed to the explanatory variables, and can be positive or negative.

The last row contains the prediction for the particular instance of interest. It is the sum of the overall mean value and the changes.

```{r q4}
question("What is the estimate of the expected value of the model's predictions over the distribution of all explanatory variables?",
  answer(paste(round(bd_joe$contribution[1] * 100, 1), "%"), TRUE),
  answer(paste(round(bd_joe$contribution[2] * 100, 1), "%")),
  answer(paste(round(bd_joe$contribution[6] * 100, 1), "%")),
  answer(paste(round(bd_joe$contribution[9] * 100, 1), "%"))
)
```

Another passenger aboard the Titanic is Lucy. She is a 18-year-old girl who also embarked in Southampton and travels first class without parents nor siblings. Her ticket costs 70 pounds.

Adjust the code and create a break-down plot for Lucy's prediction from the random forest model.

```{r ex13, exercise = TRUE}
bd_lucy <- predict_parts(___, lucy, type = ___)
plot(bd_lucy)
```

```{r ex13-solution}
bd_lucy <- predict_parts(exp_rf, lucy, type = "break_down")
plot(bd_lucy)
```

As we can see, the random forest model predicts that Lucy will very likely survive (`r paste(round(predict(exp_rf, lucy) * 100, 1))` %).

```{r q5}
question("Which three characteristics of Lucy have the biggest <u>positive</u> contribution to her predicted survival?",
  answer("age = 18"),
  answer("class = 1st", correct = TRUE),
  answer("embarked = Southampton"),
  answer("fare = 70", correct = TRUE),
  answer("gender = female", correct = TRUE),
  answer("number of siblings aboard = 0"),
  answer("number of parents aboard = 0")
)
```

### Break-down plot with interactions

Break-down plots are easy to understand. However, they can also be misleading. Break-down plots only show the <u>additive</u> attributions. Hence, the order of the explanatory in the calculation of the break-down plot matters for models including interactions. Let's illustrate this with an example.

```{r ex14, exercise = TRUE, exercise.eval = TRUE}
bd_lucy_order <- predict_parts(exp_rf, lucy, type = "break_down",
                               order = c("age", "gender", "fare", "class",
                                         "parch", "sibsp", "embarked"))
plot(bd_lucy_order)
```

After changing the order of the explanatory variables, `fare = 70` has a <u>negative</u> contribution to the prediction. Also the positive contribution of `class = 1st` has significantly increased.

There are several ways of addressing this issue. One of them is identifying interactions and taking them into account when creating a break-down plot. We can do this by specifying `type = "break_down_interactions` in the `predict_parts()` function.

```{r ex15, exercise = TRUE}
plot(predict_parts(exp_rf, lucy, type = "break_down_interactions"))
```

Another approach is using SHAP, as we will see in the next section.

### SHAP

<!-- Another way to explain individual predictions is by creating _SHapley Additive exPlanations_ (SHAP).  -->

  <!-- Let's start by visualizing SHAP values for the random forest model's prediction for Joe. -->

  <!-- ```{r sh-joe-rf-titanic, exercise=TRUE, exercise.eval=TRUE} -->
  <!-- sh_joe_rf <- predict_parts(exp_rf, joe, type = "shap") -->
  <!-- plot(sh_joe_rf, show_boxplots = FALSE) -->
  <!-- ``` -->

  <!-- Now also visualize Joe's SHAP values based upon the logistic regression model, so we can compare not only the predictions, but also the explanations of the two different models. -->

<!-- ```{r sh-joe-lms-titanic, exercise=TRUE, exercise.eval=FALSE, warning=FALSE, message=FALSE, error=FALSE} -->
<!-- sh_joe_lms <- predict_parts(___, joe, type = "shap") -->
<!-- plot(___, show_boxplots = FALSE) -->
<!-- ``` -->

<!-- ```{r sh-joe-lms-titanic-solution} -->
<!-- sh_joe_lms <- predict_parts(exp_lms, joe, type = "shap") -->
<!-- plot(sh_joe_lms, show_boxplots = FALSE) -->
<!-- ``` -->

<!-- What are the most striking differences between the explanations for Joe's prediction for the two different models? -->

  ### Ceteris-paribus

