
# Residency Identification

Overview: preference for state-supplied transaction-level residency, but we might need to create our own based on `lic$lic_res` and `cust$cust_res`

## Prioritization

1. Residency of the license type (when specified)
2.
3.

## Example Code

Using functions from package `salicprep`:

```r
sale <- res_id_type(sale, lic)
sale <- res_id_other(sale) # this can take some time to run
sale <- res_id_cust(sale, cust)
```
