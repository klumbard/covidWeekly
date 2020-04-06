#' Get aggregated weekly state-level data from covidtracking.com
#' @param absent_negs A character vector controlling what is done with rows in which negative case counts
#' aren't reported. This must be one of the strings \code{"remove"} (default) or \code{"collapse"}.
#' @return A data frame grouped by state. Contains weekly aggregated counts of positive tests, negative tests, death, and hospitalizations.
#' If the default argument \code{"remove"} of \code{absent_negs} is chosen, rows without negative incidence data in a given state are removed, along with the first
#' row in which negative cases ARE reported (because we don't know if this represents a "catchup" count or not). If the argument
#' \code{"collapse"} is chosen, the sum of the positive cases over those dates is added to the number of positive cases in the next date which does contain negative incidence.
#' The t0 column for a given state represents the day before "reliable" data started being collected, which depends on which argument was chosen for
#' dealing with \code{absent_negs}.
#' @examples
#' dat <- get_weekly_state_dat(absent_negs = "remove")
#' ## or ##
#' dat <- get_weekly_state_dat(absent_negs = "collapse")
#' @export

get_weekly_state_dat <- function(absent_negs = "remove", agg_interval = NULL){

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

  # Aggregate data into weekly intervals relative to the epiweek starting on 2020-03-01
  dat4 <- aggregate_weeks(dat3, agg_interval = agg_interval)

  # Add t0 == 1 row before first observation date
  dat_out <- get_t0(dat2, dat4, absent_negs = absent_negs)

  dat_out

}
