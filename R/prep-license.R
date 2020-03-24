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


#' Compare count of lines in raw file to imported data frame
#' 
#' Generally speaking the raw file will have one more line (header) than the 
#' data frame has rows. This function is mostly a wrapper for
#' \code{\link[salic]{count_lines_textfile}}
#' 
#' @param df data frame into which raw_file was loaded
#' @param raw_file path to raw data file
#' @family functions for preparing license data
#' @export
check_raw_lines <- function(df, raw_file) {
    raw_count <- salic::count_lines_textfile(raw_file)
    df_count <- nrow(df)
    data.frame(
        name = c("raw_file", "df", "difference"),
        row_count = c(raw_count, df_count, raw_count - df_count),
        stringsAsFactors = FALSE
    )
}
