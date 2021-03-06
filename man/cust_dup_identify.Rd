% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/finalize.R
\name{cust_dup_identify}
\alias{cust_dup_identify}
\title{Create a new (deduplicated) customer ID}
\usage{
cust_dup_identify(cust, ...)
}
\arguments{
\item{cust}{input customer table}

\item{...}{set of variables to be used for deduplication}
}
\description{
Many states require a certain amount of extra customer ID deduping. This 
function changes cust_id to a deduped version and stores the original value
in cust_id_raw. For every customer in which a duplicate(s) is found, the row 
with the lowest customer ID is used for the output cust_id.
}
\seealso{
Other finalize production data: 
\code{\link{cust_dup_demo_plot}()},
\code{\link{cust_dup_demo}()},
\code{\link{cust_dup_nomissing}()},
\code{\link{cust_dup_pct}()},
\code{\link{cust_dup_pull}()},
\code{\link{cust_dup_samp}()},
\code{\link{cust_dup_year}()},
\code{\link{res_id}}
}
\concept{finalize production data}
