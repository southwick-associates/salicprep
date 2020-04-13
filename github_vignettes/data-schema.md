
# Database Schemas

This document details the rules for storing data in a standardized format using [SQLite](https://db.rstudio.com/databases/sqlite/) databases. The file paths below refer to locations on the Data Server under `E:/SA/`. Occurences of `[state]` refer to 2-letter abbreviations and `[period]` refer to the most recent time period in year-quarter covered for a data pull (e.g., "2019-q2", "2019-q4", etc.).

### Contents

Each data pull from a state agency is to be processed through three steps, each stored in a unique database:

1. [Raw](#raw-data): `./Data-sensitive/[state]/raw-[period].sqlite3`
2. [Standard](#standard-data): `./Data-sensitive/[state]/standard.sqlite3`
3. [Production](#production-data): `./Data-production/[state]/license.sqlite3`

## Production Data

The endpoint of the data processing is a production database of 3 tables with strict data formatting rules to facilitate dashboard production. At the basic level, dashboard production requires only 9 variables (although several more variables are included for data provenance and validation). All personally-identifiable information must be excluded from the production data.

![](./img/relations.png)

### Documentation & Sample Data

The [salic vignette](https://southwick-associates.github.io/salic/articles/salic.html) includes a discussion about standardized data and the logic for the data structures employed. The `salic` package includes example production data that you can also experiment with:

```r
install.packages("remotes")
remotes::install_github("southwick-associates/salic")
data(cust, lic, sale, package = "salic")
```

### Standardization Guidelines

- Standard names should be used
- Standard coding should be used for categorical data (sex, residency, dates)
- Some variation may be needed for certain states, but this should only occur for a good reason (e.g., if an agencies' customer ID is stored as alphanumeric instead of integer)

### Schema for "lic"

The lic table corresponds to unique license types. The lic_id field should uniquely identify each row in the table (i.e., it's a primary key).

| Column Name | Description | Allowed Values | Categorical Codes | Column type | Notes | Key Status |
| --- | --- | --- | --- | --- | --- | --- |
| lic_id | unique license ID | | | int | | primary key |
| description | generic description for each lic_id | | | char | provided by state | |
| type | overall license type | fish, hunt, combo | | char | created by SA (note that "combo" refers to a license that provides both a hunting and fishing privilege) | |
| duration | how many years the license/permit lasts | 1, 2, ..., 99 | 1=1yr/short-term, 2=2yr, ..., 99=lifetime| int | necessary where multi-year/lifetime licenses are present | |
| lic_res | in-state residency for residency-specific licenses | 1, 0, NA | 1=Res, 0=Nonres | int | only needed if the agency didn't provide transaction-level residency | |
| raw_lic_id | ID for linking to raw data | | | int | row number from raw data | |
| lic_period | [period] | | | char | time period of data pull | |

### Schema for "cust"

The cust table corresponds to unique customers.

| Column Name | Description | Allowed Values | Categorical Codes | Column type | Notes | Key Status |
| --- | --- | --- | --- | --- | --- | --- |
| cust_id | unique customer ID | | | int | | primary key |
| sex | | 1, 2, NA | 1=Male, 2=Female | int | | |
| birth_year | | yyyy | | int | | |
| cust_res | customer state residency | 1, 0, NA | 1=Res, 0=Nonres | int | only needed if the agency didn't provide transaction-level residency  | |
| raw_cust_id | ID for linking to raw data | | | int | | |
| cust_period | [period] | | | char | for use when data updates are needed | |

### Schema for "sale"

The sale table corresponds to transactions (i.e., purchases of specific license types by customers).

| Column Name | Description | Allowed Values | Categorical Codes | Column type | Notes | Key Status |
| --- | --- | --- | --- | --- | --- | --- |
| cust_id | | | int | | | foreign key |
| lic_id | | | | int | | foreign key |
| year | calendar year of sale | yyyy | | int | | |
| dot | transaction (purchase) date | yyyy-mm-dd | | | char | | 
| month | calendar month of transaction | 1, 2, ..., 12 | 1=Jan, 2=Feb, ..., 12=Dec | int | | |
| res | state residency | 1, 2, NA  | 1=Res, 0=Nonres | int | | |
| raw_sale_id | ID for linking to raw data | | | int | | |
| sale_period | [period] | | | char | for use when data updates are needed | |

## Raw Data

No schemas are included for raw data; states vary in how they store data and the raw data is intended to be pulled basically as-is into a sqlite database (with the addition of an ID for each table that corresponds to row number). The data requirements are [documented here](./data-required.md).

## Standard Data

The standardized database potentially includes multiple data pulls. For example, suppose a state sends 10 years of data from Jan 1, 2009 through Dec, 31 2018. This data pull would first go into a `raw-2018-q4.sqlite3` database, and then standardized in `standard.sqlite3`. An updated set of data covers Jan 1, 2018 through Dec 31, 2019 and goes into `raw-2019-q4.sqlite3`. The `standard.sqlite3` tables should then be appended with this new dataset (a UNION in SQL parlance). The data provenance is tracked in each table using the corresponding "period" column.

Schemas for standard data match those for production data, although additional variables are included here (e.g., names and dates of births in the customer table).

### Schema for "cust"

The combination of raw_cust_id and cust_period should uniquely identify each row in the table (i.e., a composite key).

| Column Name | Description | Allowed Values | Categorical Codes | Column type | Notes | Key Status |
| --- | --- | --- | --- | --- | --- | --- |
| raw_cust_id | ID for linking to raw data | | | int | | composite key |
| cust_period | [period] | | | char | for use when data updates are needed | composite key |
| cust_id | unique customer ID | | | int | | |
| sex | | 1, 2, NA | 1=Male, 2=Female | int | | |
| dob | date of birth | yyyy-mm-dd | | char | | |
| last | last name (trimmed & lowercase) | | | char | for cust_id validation | |
| first | first name (trimmed & lowercase) | | | char | for cust_id validation | |
| state | state residency (if available) | 2-character abbreviations for US/Canada | | char | | |
| cust_res | customer residency | 1, 0, NA | 1=Res, 0=Nonres | int | | |

### Schema for "sale"

| Column Name | Description | Allowed Values | Categorical Codes | Column type | Notes | Key Status |
| --- | --- | --- | --- | --- | --- | --- |
| raw_sale_id | ID for linking to raw data | | | int | | composite key |
| sale_period | [period] | | | char | for use when data updates are needed | composite key |
| cust_id | | | | | int |  | 
| lic_id | | | | | int | | 
| year | calendar year of sale | yyyy | | | int | | 
| dot | transaction (purchase) date | yyyy-mm-dd | | | char | | 
| start_date | when license becomes effective | yyyy-mm-dd | | | char | | 
| end_date | when license expires | yyyy-mm-dd | | | char | | 
