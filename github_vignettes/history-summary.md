
# License History & Summary Data

Once license data is stored in a standardized format, several functions can be applied in sequence to build the necessary summary data. The Southwick package `dashtemplate`  (installable from the Data Server: E:/SA/Projects/R-Software/Southwick-packages/build_binary/dashtemplate_0.1.zip) includes the relevant functions. The workflow has been documented in a github repo,  [dashboard-template](https://github.com/southwick-associates/dashboard-template), for sharing with state agency folks who choose to produce their own summary data.

Information about the corresponding data structures and workflow is included in the package `salic` documentation:

- [License History](https://southwick-associates.github.io/salic/articles/salic.html#license-history) is an intermediate data structure build from the standardized cust, lic, sale tables.
- [Dashboard Metrics](https://southwick-associates.github.io/salic/articles/salic.html#dashboard-metrics) represente the calculated metrics (participants, churn, etc.) stored in a single csv file for import into Tableau.
