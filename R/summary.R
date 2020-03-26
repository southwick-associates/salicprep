# functions to summarize license data

#' Make distribution plot(s) for demographic variable(s)
#' 
#' @param df data frame with demographic variable(s)
#' @param vars name of demographic variable(s)
#' @family functions to summarize license data
#' @export
#' @examples 
#' # plot_demo(cust, c("sex", "birth_year", "cust_res"))
plot_demo <- function(df, vars) {
    plot_one <- function(df, var) {
        x <- df %>%
            count(.data[[var]]) %>%
            mutate(pct = .data$n / sum(.data$n))
        ggplot(x, aes_string(var, "pct")) +
            geom_col() +
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
