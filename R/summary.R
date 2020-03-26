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
        df %>%
            count(.data[[var]]) %>%
            mutate(pct = .data$n / sum(.data$n)) %>%
            ggplot(aes_string(var, "pct")) +
            geom_col() +
            scale_y_continuous(labels = scales::percent)
    }
    plots <- vars %>%
        sapply(function(x) plot_one(df, x), simplify = FALSE)
    gridExtra::grid.arrange(
        grobs = plots, nrow = 2,
        top = "Demographic Distributions"
    )
} 
