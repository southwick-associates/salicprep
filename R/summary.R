# functions to summarize license data

# Demographics ------------------------------------------------------------

#' Make distribution plot(s) for demographic variable(s)
#' 
#' @param df data frame with demographic variable(s)
#' @param vars name of demographic variable(s)
#' @param trend If TRUE, use stacked bar plots to trend across years
#' @family functions to summarize license data
#' @export
#' @examples 
#' # plot_demo(cust, c("sex", "birth_year", "cust_res"))
#' # hunt <- left_join(hunt, cust, by = "cust_id")
#' # plot_demo(hunt, c("sex", "cust_res"), trend = TRUE)
plot_demo <- function(df, vars, trend = FALSE) {
    plot_one <- function(df, var) {
        if (trend) { 
            p <- group_by(df, .data$year, .data[[var]]) %>%
                summarise(n = n()) %>%
                mutate(pct = .data$n / sum(.data$n)) %>%
                ggplot(aes_string("year", "pct", fill = var))
        } else { 
            p <- count(df, .data[[var]]) %>%
                mutate(pct = .data$n / sum(.data$n)) %>%
                ggplot(aes_string(var, "pct"))
        }
        p + geom_col() +
            scale_y_continuous(labels = scales::percent) +
            theme(
                axis.title.y = element_blank()
            )
    }
    plots <- vars %>%
        sapply(function(x) plot_one(df, x), simplify = FALSE)
    gridExtra::grid.arrange(
        grobs = plots, nrow = 2,
        top = "Demographic Distributions"
    )
}

# Dates -------------------------------------------------------------------

#' Summarize difference between "year" and year(dot) in sales
#' 
#' Agency provide year variables don't always correspond to calendar year of
#' sales. The resulting table tabulates the absolute difference by df$year.
#' 
#' @param df input sales dataset with "year" and "dot" variables
#' @param lastyr for descending sort of the output table
#' @family functions to summarize license data
#' @export
#' @examples 
#' # summary_year_dot(sale)
summary_year_dot <- function(df, lastyr = 2019) {
    lastyr <- as.character(lastyr)
    df <- filter(df, lubridate::year(.data$dot) != .data$year)
    if (nrow(df) == 0) {
        cat("No disagreement between year and year(dot).\n")
    } else {
        cat(
            "Absolute difference of sale$year and year(sale$dot) by sale$year.\n",  
            "Small discrepancies (e.g., year_diff == 1) are common.\n"
        )
        df %>%
            mutate(year_diff = abs(.data$year - lubridate::year(.data$dot))) %>%
            count(.data$year, .data$year_diff) %>%
            tidyr::spread(.data$year, .data$n, fill = 0) %>%
            arrange(desc(.data[[lastyr]]))
    }
}

#' Summarize date distribution by year
#' 
#' @param df data frame with date variable
#' @param date_var name of date variable
#' @param yrs years of interest
#' @param samp_size sample size to use for efficiency. If NULL, no sample will
#' be used.
#' @param facet facetting function to apply to the plot
#' @family functions to summarize license data
#' @export
#' @examples 
#' # summary_date(sale, "dot", 2010:2019)
summary_date <- function(
    df, date_var, yrs, samp_size = 100000,
    facet = function() facet_wrap(~ .data$year, scales = "free_x")
) {
    # summarize years outside select years
    df$year <- lubridate::year(df[[date_var]])
    outside <- filter(df, !.data$year %in% yrs)
    
    if (nrow(outside) > 0) {
        cat("Additional years outside of", yrs, "are included in data:\n")
        outside %>%
            count(.data$year) %>%
            arrange(desc(.data$n)) %>%
            print()
    }
    # plot years of interest
    df <- filter(df, .data$year %in% yrs)
    if (!is.null(samp_size)) {
        df <- sample_n(df, samp_size)
    }
    ggplot(df, aes_string(date_var)) +
        geom_histogram() +
        scale_x_date(date_labels = "%b") +
        ggtitle(paste("Distribution of", date_var, "by year")) +
        facet()
}

#' Summarize distribution of end_date - start_date by year
#' 
#' @inheritParams summary_date
#' @param start variable name for start date
#' @param end variable name for end date
#' @param dot variable name for transaction date
#' @family functions to summarize license data
#' @export
#' @examples 
#' # summary_duration(sale, 2010:2019)
summary_duration <- function(
    df, yrs, start = "start_date", end = "end_date", dot = "dot",
    samp_size = 100000,
    facet = function() facet_wrap(~ .data$year)
) {
    df$duration <- lubridate::interval(df[[start]], df[[end]]) / lubridate::ddays()
    df$year <- lubridate::year(df[[dot]])
    
    x <- filter(df, .data$year %in% yrs, !is.na(.data$duration))
    if (!is.null(samp_size)) {
        x <- sample_n(x, samp_size)
    }
    ggplot(x, aes(.data$duration)) +
        geom_histogram() +
        ggtitle(paste("Distribution (by transaction year) of durations",
                      "(end - start date)")) +
        facet()
}

# License Types -----------------------------------------------------------

#' Count license type customers by year
#' 
#' @param df data frame with sale data and license type info
#' @param types types to include (based on "type" variable)
#' @family functions to summarize license data
#' @export
#' @examples 
#' # sale <- left_join(sale, lic, by = "lic_id")
#' # summary_lic_types(sale)
summary_lic_types <- function(df, types = c("hunt", "fish", "combo")) {
    df %>%
        filter(.data$type %in% c("hunt", "fish", "combo")) %>%
        distinct(.data$cust_id, .data$year, .data$description) %>%
        count(.data$year, .data$description)
}

#' Make a heatmap of license type customers by year
#' 
#' @param df Count of license types as returned by \code{\link{summary_lic_types}}
#' @param truncate Truncation point for "description" variable. If NULL, no
#' truncation will be performed.
#' @family functions to summarize license data
#' @export
#' @examples 
#' # sale <- left_join(sale, lic, by = "lic_id")
#' # df <- summary_lic_types(sale)
#' # plot_lic_types(df)
plot_lic_types <- function(df, truncate = 30) {
    if (!is.null(truncate)) {
        df$description <- substr(df$description, 1, truncate)
    }
    ggplot(df, aes_string("year", "description", fill = "n")) + 
        geom_tile() +
        theme(
            legend.position = "none",
            axis.title.y = element_blank()
        ) +
        ggtitle("Customer counts by year for license types")
}
