
# Dashboard Management

Might be worthwhile to include some basic info about managing dashboard projects here. 

- [State Agency Sharing](#state-agency-sharing) provides direction on communicating with state agency folks on dashboards.
- [State-summarized Data](#state-summarized-data) provides background on agencies that choose to send summarized data rather than license data.
- [Aggregating States](#aggregating-states) gives an overview of the final step of combining data for all states.
- [Individual State Dashboards](#individual-state-dashboards) discusses the more-involved workflow for those states that receive individual dashboards.

## State Agency Sharing

Include the O365 links to documentation provided to state agencies

## State-summarized Data

Probably just a brief discussion about states that provide summarized data, and also address the need to validate these datasets (might be worth having a template workflow for that purpose).

## Aggregating States

There is a final step necessary to bring the dashboard results for all states into a single table (`E:/SA/Projects/Data-Dashboards/_Regional/`). There is a bit of analysis that happens at this stage as well:

- incorporating population data (US Census) to estimate participation rates
- creating aggregated national/regional results
- stacking all data into a single table for sending to Ben for Tableau production

## Individual State Dashboards

We use [package sadash](https://github.com/southwick-associates/sadash) for the more-involved individual state dashboards. I need to update/improve the documentation for that workflow.

