# salicprep

An R package that includes functions for preparing state license data. It also includes documentation for the preparation step of national/regional dashboards, and works in conjunction with  [package salic](https://southwick-associates.github.io/salic/) for this use case.

## Dashboad Documentation

## Installation

From the R console:

``` r
install.packages("remotes")
remotes::install_github("southwick-associates/lictemplate") # template workflow
remotes::install_github("southwick-associates/salicprep")
```
    
## Usage

Open an R console (e.g., using RStudio) and populate a directory with template files:

```r
lictemplate::new_dashboard("state-abbreviation", "time-period")
```

Open the Rstudio project just created and build the project package library with [package renv](https://rstudio.github.io/renv/index.html):

```r
renv::restore()
```

See [Workflow Overview](github_vignettes/workflow-overview.md) for data processing guidelines.
