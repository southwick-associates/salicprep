
# Customer Deduplication

Brief overview here

## Duplicate Checking Method

Using first3/first2 rather than a more generalized fuzzy-matching. Discuss the tradeoffs of false positives vs. false negatives

## Choosing Whether to Deduplicate

Give some guidelines about when we would want to perform deduplication.

## Deduplication Code Example

Using functions from salic and salicprep:

```r
# check: exact dups? (nope)
nrow(cust)
nrow(cust) == length(unique(cust$cust_id))
nrow(cust) == distinct(cust, cust_id, sex, dob, last, first, state, cust_res) %>% nrow()

# check: one customer for multiple cust_ids? (yes)
# - this is a fairly high apparent duplication rate
select(cust, dob, last, first) %>% check_dups()
dup <- count(cust, first, last, dob) %>% filter(n > 1)
summary(dup$n)

# check: using 3 letters in last, 2 letters in first
# - potentially higher false positive for lower false negative rates
cust <- cust %>%
    mutate(first2 = str_sub(first, end = 2), last3 = str_sub(last, end = 3))
select(cust, dob, last3, first2) %>% check_dups() # about 2% higher
dup <- count(cust, first2, last3, dob) %>% filter(n > 1)
summary(dup$n) 

# identify duplicates: using dob, last3, first2
cust <- cust_dup_identify(cust, dob, last3, first2)
cust_dup <- cust_dup_pull(cust)

# - summarize duplication
cust_dup_pct(cust, cust_dup)
cust_dup_demo(cust, cust_dup) %>% cust_dup_demo_plot()
cust_dup_year(cust, cust_dup, sale)

# update customer IDs in the sale table
# - this ensures we don't lose transactions associated with the old cust_id
sale <- sale %>%
    rename(cust_id_raw = cust_id) %>%
    left_join(select(cust, cust_id, cust_id_raw), by = "cust_id_raw")

# - for customers in sales but not in customer table, keep original cust_id
filter(sale, is.na(cust_id)) %>% distinct(cust_id_raw)
sale <- sale %>%
    mutate(cust_id = ifelse(is.na(cust_id), cust_id_raw, cust_id))

# remove dups from customer table
cust <- filter(cust, cust_id == cust_id_raw) # drop dups

# check
select(cust, dob, last3, first2) %>% check_dups() # ensure this is zero
filter(sale, is.na(cust_id)) # should be zero rows
```