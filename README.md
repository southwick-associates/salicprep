# salicprep

An R package for preparing state license data. It also includes relevant documentation for national/regional dashboards and works in conjunction with [package salic](https://southwick-associates.github.io/salic/) for this use case.

## Documentation

Written for national/regional dashboards, although potentially relevant for other R-based license projects:

- [Dashboard Analyst Introduction](github_vignettes/dashboard-overview.md)
    + [Data Server Setup & Rules](github_vignettes/server-setup.md)
    + TODO: [R on Server Info](github_vignettes/r-on-server.md)
    + [Rstudio Recommended Settings](github_vignettes/rstudio-settings.md)
- [Workflow Overview](github_vignettes/workflow-overview.md)
    + [Data required from states](github_vignettes/data-required.md)
    + [Database Schemas](github_vignettes/data-schema.md)
    + TODO: [Customer Deduplication](github_vignettes/customer-deduplication.md)
    + TODO: [Residency Identification](github_vignettes/residency-identification.md)
    + [License History & Summary Data](github_vignettes/history-summary.md)
- TODO: [Dashboard Management](github_vignettes/dashboard-management.md)

## Installation

From the R console:

``` r
install.packages("remotes")
remotes::install_github("southwick-associates/salicprep")
```
    
## Usage

- See [package lictemplate](https://github.com/southwick-associates/lictemplate) for populating template files for a new state.
- See [Workflow Overview](github_vignettes/workflow-overview.md) for data processing guidelines.
