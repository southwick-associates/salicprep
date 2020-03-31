
# Workflow Overview

This document outlines the workflow for preparing license data (particularly for dashboards). It's an R-based workflow that utilizes custom R packages developed by Southwick ([salic](https://southwick-associates.github.io/salic/), [salicprep](https://github.com/southwick-associates/salicprep), [lictemplate](https://github.com/southwick-associates/lictemplate), [dashtemplate](https://github.com/southwick-associates/dashboard-template),
[workflow](https://github.com/southwick-associates/workflow)). The analysis is intended to be performed using the Southwick Data Server, which keeps all sensitive data confined to a single location. See [Data Server Setup & Rules](server-setup.md) for more information about the server.

## Server Resources

The dashboard analysis files are separated from data files:

| File Path | Function |
| --- | ---|
| E:/SA/Projects/Data-Dashboards/ | Analysis (code, etc.) by state |
| E:/SA/Data-sensitive/Data-Dashboards/ | License Data with personally-identifiable info |
| E:/SA/Data-production/Data-Dashboards/ | Anonymized License Data for producing dashboards |

### Software

A number of software applications are available on the Data Server in `E:/SA/Program Files/`. These don't (currently) have shortcuts and file associations, so you might need to add those manually by finding the file exe (e.g., right click > open with > browse for program). Notable applications:

- RStudio: An IDE for R. I recommend [some modifications](rstudio-settings.md) to the default user settings.
- DB Browser for SQLite: Provides an interactive way of exploring the SQLite datbases.
- Gedit: A text editor.
- Ron's Editor: A spreadsheet-like csv editor, potentially useful for manual operations on license type tables.

## Analysis Steps

A suggested data processing sequence is outlined below.

0. [Initialize New State](#0-initialize-new-state)
1. [Load Raw date into SQLite](#1-load-raw-data-into-sqlite)
2. [Standardize Data](#2-standardize-data)
3. [Prep License Type Categories](#3-prep-license-type-categories)
4. [Initial Validation](#4-initial-validation)
5. [Finalize Production Data](#5-finalize-production-data)
6. [Final Validation](#6-final-validation)

After data processing a dashboard summary data table can be built using provided functions. see [License History & Summary Data](history-summary.md) for more info.

### 0-Initialize new state

From an R console on the server, run `lictemplate::new_project("state-abbreviation", "period")` to populate template files and folders for dashbaord production. Then open the corresponding ".Rproj" file created and run `renv::restore()` to setup the packages needed for the template workflow.

### 1-Load Raw data into SQLite

The purpose of this step is to get the raw license data into a format that is easily usable in analysis. [SQLite](https://db.rstudio.com/databases/sqlite/) databases are useful because they are easily queriable with R. The raw data should be pulled in mostly as-is, to provide an accurate (and complete) representation of the raw data in a database.

**Check**: At this stage you should also check that none of the columns (variables) specified in the [Data Request](data-required.md) are missing from the raw data. 

**Note about row IDs**: Adding a unique row ID ensures a means of joining production data back to raw data in the future.

**Typical Data Tables:**

- lic: The state will usually provide a license type table, typically with a few hundred rows and several columns that describe each available license type. These should be joinable to the sales table with a license ID.

- cust: The state typically provides a fairly large file (often in the millions of rows) with information about each customer. These datasets contain highly sensitive personally-identifiable information. This should be joinable to the sales table with a customer ID.

- sale: State license/permit sales (transactions) over 10 years are often in the tens of millions of rows. Sometimes the state will separate these into multiple files, but we will usually want to store sales as a single table.

### 2-Standardize Data

Saving a standardized intermediate database simplifies downstream validation and final preparation. The [Database Schema](./data-schema.md) provides details about variables to include and how categorical variables should be coded.

**Check:**: This step naturally involves a certain amount of data validation, and recoding summaries for relevant variables (gender, residency, etc.) should be documented for future reference. Of particular interest are values that get stored as NA (missing) in the standardized tables. These may be junk data (e.g., data entry errors) or stand-ins for missing values (e.g., "U" for unknown gender).

Standardized data rules can be checked with a function: `salicprep::data_check_standard()`

### 3-Prep License Type Categories

The license type table from the state may require some manual editing. We will need to create a "type" variable which provides logic for identifying hunters and anglers based on license purchases:

- An angler is anyone who buys a license with `lic$type` "fish" or "combo" in a given year.
- An hunter is anyone who buys a license with `lic$type` "hunt" or "combo" in a given year.

### 4-Initial Validation

This step is intended to catch any obvious data problems early. Most data issues can be revealed by looking at how counts change year-to-year (the customer counts in particular don’t usually change much). Several checks are useful:

- Total customer counts by year (overall and separately for hunters and anglers). Comparing to the [USFWS Historical License Sales](https://www.fws.gov/wsfrprograms/Subpages/LicenseInfo/LicenseIndex.htm) can be useful for a new state.
- Demographic breakouts for customers and separately for hunters/anglers.
- Sale date variables, particularly correspondence between transaction date (`sale$dot`) and license year (`sale$year`). For dashboards, we will be using calendar year (i.e., based on transaction date), but the year variable provided by agencies doesn't always line up with calendar year.
- Gaps in specific license types across years, which might identify missing data issues.

### 5-Finalize Production Data

The anonymized production data is created at this stage.

**Customer Deduplication:** No duplicates should be included in the production customer table, and we will want to check the state-supplied customer ID at this stage by using first name, last name, and date of birth (if provided by the agency). See [Customer Deduplication](customer-deduplication.md) for more info.

**Residency Identifcation:**: State agencies may or may not provide a transaction-level residency variable. If not, a sequence of steps will need to be performed to identify residency. See [Residency Identification](residency-identification.md) for more info.

### 6-Final Validation

This step involves summarizing the data in various ways to gain confidence in the trends it presents (overall, by demographic, etc.), and potentially identify any problems in the data (which may require discussion with state agency folks to sort out). To some degree it repeats the initial validation, but summaries may look different for production data due to customer deduplication, etc.
