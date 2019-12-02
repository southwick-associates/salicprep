# salicprep

A Southwick internal package for preparing agency data. Includes template code and generic functions for producing standardized license data. Salicprep extends the [salic package](https://southwick-associates.github.io/salic/) to provide a more generic workflow that isn't necessarily tied to dashboard production. 

## Installation

- First, install R: <https://www.r-project.org/>
- Then install salicprep and it's dependencies from the R console:

``` r
install.packages(c("tidyverse", "data.table", "devtools"))
devtools::install_github("southwick-associates/salic")
devtools::install_github("southwick-associates/salicprep")
```

## Usage

See the vignette for an introduction. A project (with template scripts) can be initialized with a provided function:

```r
salicprep::new_project("E:/SA/Projects/project-name")
```