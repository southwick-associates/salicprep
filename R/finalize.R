# finalize production data

# Customer Deduplication --------------------------------------------------

#' Create a new (deduplicated) customer ID
#' 
#' Many states require a certain amount of extra customer ID deduping. This 
#' function changes cust_id to a deduped version and stores the original value
#' in cust_id_raw. For every customer in which a duplicate(s) is found, the row 
#' with the lowest customer ID is used for the output cust_id.
#' 
#' @param cust input customer table
#' @param ... set of variables to be used for deduplication
#' @family finalize production data
#' @export
cust_dup_identify <- function(cust, ...) {
    dedup_vars <- enquos(...)
    dedup <- cust %>%
        arrange(.data$cust_id) %>%
        group_by(!!! dedup_vars) %>%
        slice(1L) %>%
        ungroup() %>%
        select(.data$cust_id, !!! dedup_vars)
    cust %>%
        rename(cust_id_raw = .data$cust_id) %>%
        left_join(dedup)
}

#' Set cust_id to cust_id_raw where there are missing values in select variables
#' 
#' This prevents a situation in which multiple customers with missing values (e.g.,
#' in names) are identified as the same customer. To be run following
#' \code{\link{cust_dup_identify}}
#' 
#' @param cust input customer table
#' @param vars variables to look for missing values
#' @family finalize production data
#' @export
cust_dup_nomissing <- function(cust, vars) {
    # summary before: customers per row
    before <- length(unique(cust$cust_id))
    
    for (i in vars) {
        cust <- cust %>% mutate(
            cust_id = ifelse(is.na(.data[[i]]), .data$cust_id_raw, .data$cust_id)
        )
    }
    # summary after: customers per row
    after <- length(unique(cust$cust_id))
    cat("The nomissing correction reduces unique customer IDs:\n")
    tibble::tribble(
        ~Group, ~`Unique customer IDs`,
        "Before Correction", before,
        "Afer Correction", after,
        "Difference", after - before
    ) %>% print()
    
    cust
}

#' Pull customer records where duplicates were found
#' 
#' This table is intended to be stored in case deduplcation needs to be checked
#' downstream. The output only includes those customers in which a duplicate was 
#' found, containing all corresponding rows from the raw customer table.
#' 
#' @inheritParams cust_dup_identify
#' @family finalize production data
#' @export
cust_dup_pull <- function(cust) {
    dup <- cust %>%
        count(.data$cust_id) %>%
        filter(n > 1) 
    cust %>%
        semi_join(dup, by = "cust_id")
}

#' Pull a sample of duplicated customers and their sales
#' 
#' Only select variables are included, with a \code{\link[dplyr]{distinct}}
#' operation run at the end.
#' 
#' @inheritParams cust_dup_pct
#' @param sale data frame with uncorrected customer IDs
#' @param samp_size number of customers to pull in sample
#' @param vars variables to include in output
#' @family finalize production data
#' @export
cust_dup_samp <- function(
    cust_dup, sale, samp_size = 10,
    vars = c("cust_id", "cust_id_raw", "year", "first", "last", "dob", "zip4dp")
) {
    dup_samp <- cust_dup %>%
        distinct(.data$cust_id) %>% 
        sample_n(samp_size)
    dup_samp %>%
        left_join(cust_dup, by = "cust_id") %>%
        left_join(rename(sale, cust_id_raw = .data$cust_id), by = "cust_id_raw") %>%
        select(tidyselect::any_of(vars)) %>%
        distinct() %>%
        data.frame()
}

#' Summarize percent of customers with extra rows in raw table
#' 
#' Percent of customers: (based on deduplicated count) with extra
#' rows in the raw customer ID table. This will give a lower percentage
#' than \code{\link[salic]{check_dups}} because it only counts duplicated
#' customers once. I consider this to be a more meaningful measure of the 
#' customer duplication rate.
#' 
#' @inheritParams cust_dup_identify
#' @param cust_dup table of customers (with dups) produced by 
#' \code{\link{cust_dup_pull}}
#' @param return_msg If TRUE, returns a message with the duplication percentage,
#' otherwise, the duplication percentage measure
#' @family finalize production data
#' @export
cust_dup_pct <- function(cust, cust_dup, return_msg = TRUE) {
    all_cnt <- length(unique(cust$cust_id))
    with_dup_cnt <- cust_dup %>%
        distinct(.data$cust_id) %>%
        nrow()
    dup_pct <- round(with_dup_cnt / all_cnt * 100, 2)
    if (!return_msg) {
        return(dup_pct)
    }
    message(
        "\nDuplication Summary:\n- cust_dup_pct: ", dup_pct,
        "% of customers had more than one cust_id in the raw data"
    )
}

#' Demographic breakouts for customer duplication
#' 
#' Runs \code{\link{cust_dup_pct}} across demographic variables. By default
#' requires sex, cust_res, and birth_year to be present in the customer tables.
#' Returns a data frame with breakouts for each specified demographic.
#' 
#' @inheritParams cust_dup_pct
#' @param demos name(s) of demographic variables to check
#' @family finalize production data
#' @export
cust_dup_demo <- function(
    cust, cust_dup, demos = c("sex", "cust_res", "birth_year")
) {
    # get category labels for res & sex
    add_labels <- function(df) {
        rename(df, res = .data$cust_res) %>% 
            salic::label_categories() %>%
            rename(cust_res = .data$res)
    }
    cust <- add_labels(cust)
    cust_dup <- add_labels(cust_dup)
    
    # define function to run summary for one demographic
    run_demo <- function(cust, cust_dup, var) {
        x <- list(
            "cust" = split(cust, cust[[var]]), 
            "cust_dup" = split(cust_dup, cust_dup[[var]])
        )
        pct <- sapply(names(x[["cust_dup"]]), function(nm) {
            cust_dup_pct(x[["cust"]][[nm]], x[["cust_dup"]][[nm]], FALSE)
        })
        dplyr::tibble(var = var, cat = names(pct), dup_pct = pct)
    }
    # apply across all demographics
    demos %>%
        sapply(function(var) run_demo(cust, cust_dup, var), simplify = FALSE) %>%
        bind_rows()
}

#' Plot results of cust_dup_demo()
#' 
#' @param df_pct output of \code{\link{cust_dup_demo}}
#' @family finalize production data
#' @export
cust_dup_demo_plot <- function(df_pct) {
    demos <- unique(df_pct$var)
    plot_demo <- function(x, varnm) {
        x <- filter(x, .data$var == varnm)
        if (varnm == "birth_year") x$cat <- as.numeric(x$cat)
        p <- x %>%
            ggplot(aes_string("cat", "dup_pct")) +
            geom_col() +
            theme(axis.title.x = element_blank())
        if (varnm != "birth_year") {
            return(p)
        }
        p <- p + scale_x_continuous(breaks = seq(1900, 2020, 10))
    }
    plots <- sapply(demos, function(nm) plot_demo(df_pct, nm), simplify = FALSE)
    gridExtra::grid.arrange(grobs = plots)
}

#' Annual dynamics for customer duplication
#' 
#' License system changes often lead to a spike in customer dups in comparing
#' new and old data. It can be useful to be aware of this.
#' 
#' Note that this function might not reveal a break point (i.e., from a change
#' to a new licensing system), the duplication identification would probably 
#' need to be iterative, so will probably need to rewrite this function to reveal 
#' such a pattern. This wasn't a priority in Dec 2019.
#' 
#' @export
#' @inheritParams cust_dup_pct
#' @param sale sale table for exploring year-to-year duplication patterns
#' @family finalize production data
#' @export
cust_dup_year <- function(cust, cust_dup, sale) {
    sale <- sale %>%
        rename(cust_id_raw = .data$cust_id) %>%
        right_join(select(cust, .data$cust_id, .data$cust_id_raw), 
                   by = "cust_id_raw") %>%
        distinct(.data$cust_id, .data$year)
    cnt_dup <- sale %>%
        semi_join(cust_dup, by = "cust_id") %>% 
        count(.data$year)
    sale %>%
        count(.data$year) %>%
        left_join(cnt_dup, by = "year", suffix = c(".all", ".dup")) %>%
        mutate(pct_dup = .data$n.dup / .data$n.all * 100)
}

# Sale Res Identification -------------------------------------------------

#' Identify sales residency
#' 
#' The intended use is to prioritize residency identification using 3 different
#' methods: (1) by license type, (2) by other sales by the same customer, and 
#' (3) based on customer address.
#' 
#' @param sale,cust,lic license data frames
#' @param var variable name that holds reference residency variable
#' @param caption text to be printed above identification summary
#' @family finalize production data
#' @name res_id
NULL

#' @describeIn res_id Identify sales residency based on license type
#' 
#' This is the clearest identifier of residency, so it should be given first 
#' priority in identifying residency at the transaction level.
#' @export
res_id_type <- function(
    sale, lic, var = "lic_res", caption = "Identification: by license type"
) {
    lic <- select(lic, .data$lic_id, lic_res = .data[[var]])
    sale <- sale %>%
        left_join(lic, by = "lic_id") %>%
        mutate(res = .data$lic_res) %>%
        select(-.data$lic_res)
    res_id_summary(sale, caption) %>% print()
    sale
}

#' @describeIn res_id Identify residency based on other sales by customer
#' 
#' Based on the assumption that recent sales by the same customer can be used
#' to identify residency. More recent sales are given priority over distant sales.
#' @export
res_id_other <- function(
    sale, caption = "Identification: other sales by the same customer"
) {
    # separate sales into 2 groups (with vs. without residency defined)
    no_res <- sale %>%
        filter(is.na(.data$res)) %>% 
        select(.data$cust_id, .data$year)
    
    other_res <- sale %>%
        filter(!is.na(.data$res)) %>% 
        select(.data$cust_id, .data$year, .data$res)
    
    # function to identify one year of unknown residents
    identify_year <- function(slct_year) {
        df <- filter(no_res, .data$year == slct_year)
        
        # preferentially pick another sale by that customer that is nearest in year
        # - prefer res == 1 if there are 2+ sales in the same year
        new_res <- other_res %>%
            semi_join(df, by = "cust_id") %>%
            mutate(diff = abs(slct_year - .data$year)) %>%
            arrange(.data$diff, desc(.data$res)) %>%
            group_by(.data$cust_id) %>%
            slice(1L) %>%
            select(.data$cust_id, other_res = .data$res) %>%
            ungroup()
        
        # update sales in selected year
        sale %>%
            filter(.data$year == slct_year) %>%
            left_join(new_res, by = "cust_id") %>%
            mutate(res = ifelse(is.na(.data$res), .data$other_res, .data$res)) %>%
            select(-.data$other_res)
    }
    sale <- sort(unique(sale$year)) %>%
        sapply(identify_year, simplify = FALSE) %>%
        bind_rows()
    res_id_summary(sale, caption) %>% print()
    sale
}

#' @describeIn res_id Identify residency based on customer address
#' @export
res_id_cust <- function(
    sale, cust, var = "cust_res", caption = "Identification: by customer address"
) {
    cust <- cust %>%
        select(.data$cust_id, cust_res = .data[[var]])
    sale <- sale %>%
        left_join(cust, by = "cust_id") %>%
        mutate(res = ifelse(is.na(.data$res), .data$cust_res, .data$res)) %>%
        select(-.data$cust_res)
    res_id_summary(sale, caption) %>% print()
    sale
}

#' @describeIn res_id Summarize current residency percentages
#' 
#' This is intended to be run as part of the residency identification functions
#' @export
res_id_summary <- function(sale, caption = "") {
    x <- sale %>%
        count(.data$res) %>%
        mutate(pct = round(n / sum(n) * 100, 2))
    cat("\n", caption, "\n", paste(rep("-", nchar(caption)), collapse = ""), 
        "\n", sep = "")
    data.frame(x)
}
