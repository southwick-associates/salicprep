# salicprep

A Southwick internal package for preparing agency data; salicprep includes template code and functions for standardizing license data. It extends [salic](https://southwick-associates.github.io/salic/) to provide a more generic workflow that isn't tied to dashboard production. 

## Installation

- First, install R: <https://www.r-project.org/>
- Then install salicprep and it's dependencies from the R console:

``` r
install.packages(c("dplyr", "ggplot2", "gridExtra", "devtools"))
devtools::install_github("southwick-associates/salic")
devtools::install_github("southwick-associates/salicprep")
```

## Usage

See the vignette (to be written) for an introduction. A project with template files and folders can be initialized from the R console:

```r
# example project on data server
salicprep::new_project("E:/SA/Projects/project-name")
```

TODO: include a screenshot of the file structure in "Analysis"
