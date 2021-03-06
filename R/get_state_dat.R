#' Get aggregated state-level data from covidtracking.com
#' @param absent_negs A character vector controlling what is done with rows in which negative case counts
#' aren't reported. This must be one of the strings \code{"remove"} (default) or \code{"collapse"}.
#' @param agg_interval A positive whole number giving the desired length of aggregation intervals.
#' @param t0 A date in the format "mm-dd-yyyy" which will serve as the "anchor" time from which we aggregate forwards
#' @return A data frame grouped by state. Contains aggregated counts of positive tests, negative tests, death, and hospitalizations.
#' If the default argument \code{"remove"} of \code{absent_negs} is chosen, rows without negative incidence data in a given state are removed, along with the first
#' row in which negative cases ARE reported (because we don't know if this represents a "catchup" count or not). If the argument
#' \code{"collapse"} is chosen, the sum of the positive cases over those dates is added to the number of positive cases in the next date which does contain negative incidence.
#' @examples
#' dat <- get_state_dat(absent_negs = "remove", agg_interval = 7, t0 = "2020-03-15")
#' ## or ##
#' dat <- get_state_dat(absent_negs = "collapse", agg_interval = 7, t0 = "2020-03-15")
#' @export

get_state_dat <- function(absent_negs = "remove", agg_interval = NULL, t0 = "2020-03-01"){

  # Load daily cumulative state counts
  dat <- pull_dat()

  # Data cleaning (remove columns, rename columns, arrange by state, etc)
  dat2 <- clean_dat(dat)

  if(absent_negs == "remove"){
    # For stretches where negatives are NA, sum remove those rows and the
    # next row chronologically
    dat3 <- remove_absent_negs(dat2)
  } else if(absent_negs == "collapse"){
    # For stretches where negatives are NA, sum  the positive cases over that
    # stretch and let the next non-NA data "absorb" their contribution
    dat3 <- collapse_absent_negs(dat2)
  }

  # Aggregate data into intervals relative to the epiweek starting on 2020-03-01
  dat4 <- aggregate_weeks(dat3, agg_interval = agg_interval, t0 = t0)

  # Add t0 == 1 row before first observation date
  dat_out <- get_t0(dat_weekly = dat4, absent_negs = absent_negs, agg_interval = agg_interval)

  dat_out

}
