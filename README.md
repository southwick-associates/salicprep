# salicprep

A Southwick internal package for preparing agency data; salicprep includes template code and functions for standardizing license data. It extends [salic](https://southwick-associates.github.io/salic/) to provide a more generic workflow that isn't tied to dashboard production. 

## Installation

To install salicprep and it's dependencies from the R console:

``` r
install.packages(c("dplyr", "ggplot2", "gridExtra", "devtools"))
devtools::install_github("southwick-associates/salic")
devtools::install_github("southwick-associates/salicprep")
```

## Usage

See the vignette (to be written) for an introduction.

### Setup a new project

If creating a new project from scratch, I recommend [using Rstudio](https://r4ds.had.co.nz/workflow-projects.html#rstudio-projects). Then run the setup functions from the R console:

- if using a [Southwick R installation](https://github.com/southwick-associates/R-setup): `saproj::new_project("project-name")`
- install R packages as described in "Installation" above

### Setup Template Files

Run `salicprep::setup_template()` from the R console to populate a set of generic license data processing scripts.
