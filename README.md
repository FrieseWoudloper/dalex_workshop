# dalextutorial

Branch   |[![Travis CI logo](pics/TravisCI.png)](https://travis-ci.org)
---------|------------------------------------------------------------------------------------------------------------------------------------------------
`master` |[![Build Status](https://travis-ci.org/richelbilderbeek/dalextutorial.svg?branch=master)](https://travis-ci.org/richelbilderbeek/dalextutorial)
`develop`|[![Build Status](https://travis-ci.org/richelbilderbeek/dalextutorial.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/dalextutorial)

## Install and run

Clone the repository:

```
git clone https://github.com/friesewoudloper/dalextutorial

usethis::install_github("rstudio-education", "gradethis")
```

In Rstudio, do 'Open Project' on `dalextutorial.Rproj`.

In the top-right panel, click the 'Build' tab, then 'Install and restart':

![](install.png)

If there is a package missing, install it from RStudio 
using 'Tools | Install package'.

To install the `gradethis` package, use:

```r
remotes::install_github("rstudio-education/gradethis")
```

