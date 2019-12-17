# preparing license data

#' Convert all date columns in a data frame to character
#' 
#' A convenience function to prepare for sqlite, which doesn't translate R dates 
#' when writing data. It's a very slow operation, so not efficient with regard to
#' computation, but the alternative is to specify as character on load; 
#' a tedious thing to do with a larger number of variables.
#' 
#' @param df input data frame
#' @family functions for preparing license data
#' @export
date_to_char <- function(df) {
    is_date_col <- sapply(names(df), function(x) {
        lubridate::is.POSIXt(df[[x]]) || lubridate::is.POSIXlt(df[[x]]) || 
            lubridate::is.POSIXct(df[[x]]) || lubridate::is.Date(df[[x]]) 
    }) %>% 
        unlist()
    date_cols <- names(df)[is_date_col]
    df[date_cols] <- lapply(df[date_cols], as.character)
    df
}
