# Checks for Data

#' Check standard data (cust, sale) formatting rules
#' 
#' Produces warnings if any checks fail (stays silent on success).
#' This function is simply a wrapper for several calls to \code{\link[salic]{data_check_table}} 
#' and \code{\link[salic]{data_foreign_key}}. Rules are designed to ensure:
#' \itemize{
#'   \item primary keys are unique and non-missing
#'   \item all required variables are present
#'   \item variables only contain prescribed values
#'   \item foreign keys are present in relevant primary key table (e.g., all
#'   sale$cust_id can be found in cust$cust_id)
#' }
#' 
#' @inheritParams salic::data_check
#' @param sale_year1 First allowed year for sale dates
#' @family functions to check data format
#' @export
data_check_standard <- function (cust, lic, sale, sale_year1 = 2009)  {
    salic::data_check_table(
        cust, df_name = "cust", primary_key = "cust_id",
        required_vars = c(
            "cust_id", "sex", "dob", "last", "first", "state", "cust_res", 
            "raw_cust_id", "cust_period"
        ),
        allowed_values = list(
            sex = c(1, 2, NA),
            dob = c(variable_allowed_dates(1700), NA)
        )
    )
    salic::data_foreign_key(sale, cust, "cust_id")
    salic::data_foreign_key(sale, lic, "lic_id")
    salic::data_check_table(
        sale, df_name = "sale", primary_key = NULL,
        required_vars = c(
            "cust_id", "lic_id", "year", "dot", "start_date", "end_date",
            "raw_sale_id", "sale_period"
        ),
        allowed_values = list(
            year = sale_year1:substr(Sys.Date(), 1, 4),
            dot = c(variable_allowed_dates(sale_year1), NA),
            start_date = c(variable_allowed_dates(sale_year1), NA),
            end_date = c(variable_allowed_dates(sale_year1), NA)
        )
    )
}


#' Get a set of all dates that satisfy given conditions
#' 
#' This is intended to be called from \code{\link{data_check_standard}}
#' for checkiing date variables. It returns a vector of dates in a "yyyy-mm-dd"
#' format.
#' 
#' @param year1 first allowed year
#' @param valid_years set of allowed years
#' @param valid_months set of allowed months
#' @param valid_days set of allwed days
#' @family functions to check data format
#' @export
variable_allowed_dates <- function(
    year1,
    valid_years =  year1:substr(Sys.Date(), 1, 4), 
    valid_months = c(paste0("0", 1:9), 10:12),
    valid_days = c(paste0("0", 1:9), 10:31)
) {
    year_month <- valid_years %>%
        sapply(function(x) paste(x, valid_months, sep = "-"), simplify = FALSE) %>%
        unlist()
    dates <- year_month %>%
        sapply(function(x) paste(x, valid_days, sep = "-"), simplify = FALSE) %>%
        unlist()
    names(dates) <- NULL
    dates
}