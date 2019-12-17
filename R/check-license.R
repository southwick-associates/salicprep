# validating license data

#' Plot sale date distributions
#' 
#' Convenience function to check for unusual patterns or variation between years
#' 
#' @param sale sales data frame with year & var to plot
#' @param var date variable name to count
#' @param angle axis.text.x angle for plot
#' @family functions for validating license data
#' @export
plot_dates <- function(sale, var = "dot", angle = 30) {
    if (!lubridate::is.Date(sale[[var]])) {
        sale[[var]] <- lubridate::ymd(sale[[var]])
    }
    sale %>%
        ggplot(aes_string(var)) +
        geom_freqpoly() +
        facet_wrap(~ year, scales = "free_x") +
        ggtitle(paste("Count of Sales by", var)) +
        theme(axis.text.x = element_text(angle = angle, hjust = 1))
}
