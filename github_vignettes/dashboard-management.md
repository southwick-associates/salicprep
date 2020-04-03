
# Dashboard Management

This document is intended as a portal for dashboard analysis management. It covers a number of topics that go beyond what is needed for analysts producing dashboard summary data for individual states as part of the national/regional dashboard project.

### Individual State Dashboards

Note that [package sadash](https://github.com/southwick-associates/sadash) was written for processing the more-involved individual state dashboards. Relevant documentation is stored in that repository.

### State-supplied Summary Data

Certain states will send summarized data (of dashboard metrics) rather than sensitive license data. This will require validation on our part, and likely editing in certain cases (and back-and-forth with agency folks to resolve questions). I will be creating a template workflow for processing these summary data.

### Archived Documentation

The dashboard documentation was originally stored in [Office 365 >> Data Dashboards >> _Analyst Docs](https://southwickassociatesinc.sharepoint.com/:f:/s/datadashboards/EqI3PX-tnbtBreBfPa-87-UBwcYlg5k34CKuHMcY5dj9nw?e=uOBtDI) These documents are primarily focused on individual state dashboards, and are linked here for future reference. The Github documentation was written as a replacement for the O365 documentation.

### State Agency Communication

The dashboard analysis manager will be coordinating with Lisa P on communication with state agencies. Initially, this will involve sending data request documents to states, stored in [Office 365 >> Data Dashboards >> _Data Requests](https://southwickassociatesinc.sharepoint.com/:f:/s/datadashboards/EqfCkmTfLxhEjcuF3sJUexgBmSEH0bEdMYhRcWfNM4s7jA?e=PRth6I):

- [License Data Requirements](https://southwickassociatesinc.sharepoint.com/:w:/s/datadashboards/EdpmT1PXnYhHiAUBAnLj-GQByZhMxXTYRBShHmHZumiJ-Q?e=zkXRmg) for states that send sensitive license data
- [Summary Data Requirements](https://southwickassociatesinc.sharepoint.com/:w:/s/datadashboards/Ef05MOWznuRLtc0lkfNbTYwBQhykyrZLW7RheM7ZoksSPQ?e=aUyuzn) for states that choose not to send license data
- [Summary Data Example](https://southwickassociatesinc.sharepoint.com/:x:/s/datadashboards/EY1-RDDhCtVLuLDnapCVIrIBMFAzC-beAuiVuZlFiND0fw?e=Iha6au) to provide a concrete example of the summarized data format we are requesting

### Combining States

Individual state summary data is produced by dashboard analysts, but a final aggregation step is needed in order to:

1. Estimate participation rates using US Census data
2. Produce averaged metrics for regions and the nation as a whole
3. Combine all geographic levels (individual states, regions, US) into a single table for Tableau import

This workflow is stored on the server: `E:/SA/Projects/Data-Dashboards/_Regional/`
