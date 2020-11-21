# dalextutorial

## Install and run

Install `dalextutorial` from Github:

```
install.packages(c("learnr", "remotes"))
remotes::install_github("friesewoudloper/dalextutorial")
```


If you get the question below, it is probably best to chose `1` and update all packages.

```
These packages have more recent versions available.
It is recommended to update all of them.
Which would you like to update?

 1: All  
```

Now, you are ready to go:

```
learnr::run_tutorial("ema_with_dalex", "dalextutorial")
```
