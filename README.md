# salicprep

An R package that includes functions for preparing state license data. It also includes documentation for the preparation step of national/regional dashboards, and works in conjunction with  [package salic](https://southwick-associates.github.io/salic/) for this use case.

## Documentation

Written for national/regional dashboards, although potentially relevant for other R-based license projects:

- [Dashboard Analyst Introduction](github_vignettes/dashboard-overview.md)
- [Workflow Overview (incomplete)](github_vignettes/workflow-overview.md)
    + [Data Server Setup & Guidelines](github_vignettes/server-setup.md)
    + [Rstudio Recommended Settings](github_vignettes/rstudio-settings.md)
- [Data required from states](github_vignettes/data-required.md)
- [Database Schemas](github_vignettes/data-schema.md)

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
