
# Dashboard Management

This document is intended as a portal for dashboard analysis management. It covers a number of topics that go beyond what is needed for analysts producing dashboard summary data for individual states as part of the national/regional dashboard project.

### Contents

- [State Agency Communication](#state-agency-communication) 
- [State-summarized Data](#state-summarized-data) 
- [Combining States for National/Regional Dashboard](#combining-states) 
- [Individual State Dashboards](#individual-state-dashboards) 

## State Agency Communication

The dashboard analysis manager will be coordinating with Lisa P on communication with state agencies. Initially, this will involve sending data request documents to states, stored in the O365 Data Dashboards group:

- [License Data Requirements](https://southwickassociatesinc.sharepoint.com/:w:/s/datadashboards/EdpmT1PXnYhHiAUBAnLj-GQByZhMxXTYRBShHmHZumiJ-Q?e=zkXRmg) for states that send sensitive license data
- [Summary Data Requirements](https://southwickassociatesinc.sharepoint.com/:w:/s/datadashboards/Ef05MOWznuRLtc0lkfNbTYwBQhykyrZLW7RheM7ZoksSPQ?e=aUyuzn) for states that choose not to send license data
    + [Summary Data Example](https://southwickassociatesinc.sharepoint.com/:x:/s/datadashboards/EY1-RDDhCtVLuLDnapCVIrIBMFAzC-beAuiVuZlFiND0fw?e=Iha6au) to provide a concrete example of the data format we are requesting

## State-summarized Data

provides background on agencies that choose to send summarized data rather than license data.

Probably just a brief discussion about states that provide summarized data, and also address the need to validate these datasets (might be worth having a template workflow for that purpose).

## Combining States

gives an overview of the final step of combining data for all states.

There is a final step necessary to bring the dashboard results for all states into a single table (`E:/SA/Projects/Data-Dashboards/_Regional/`). There is a bit of analysis that happens at this stage as well:

- incorporating population data (US Census) to estimate participation rates
- creating aggregated national/regional results
- stacking all data into a single table for sending to Ben for Tableau production

## Individual State Dashboards

discusses the more-involved workflow for those states that receive individual dashboards.

We use [package sadash](https://github.com/southwick-associates/sadash) for the more-involved individual state dashboards. I need to update/improve the documentation for that workflow.

