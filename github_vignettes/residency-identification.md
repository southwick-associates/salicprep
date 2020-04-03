
# Residency Identification

State residency (in-state, out-of-state) is a customer variable that may change over time. For this reason, it is stored in the sale table of the production database. Agencies may provide a transaction-specific residency variable, in which case no identification is needed on our part. Otherwise, the workflow below should be used to identify residency.

## Prioritization

A 3-step residency identification process is usually sufficient to reach near 100% residency identification. Because residency is often license-type-specific, priority is given to that variable in identifying residency. When not available, we can rely upon other transactions by the same customer or the customer address.

### Steps

1. Residency of the license type (when specified)
2. Other purchases by the same customer (for those customers with known residency)
3. Customer residency variable (usually based on a `state` variable)

### Example Code

Three functions from package `salicprep` have been included to make it easy to identify residency with the above prioritization. This is intended to be performed in the `05-final.R` script which builds the production database.

#### 05-finalize.R

```r
# identify residency
# -  if not provided by state at the transaction level
sale <- res_id_type(sale, lic)
sale <- res_id_other(sale) # this can take some time to run
sale <- res_id_cust(sale, cust)
```
