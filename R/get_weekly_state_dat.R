#' Get aggregated weekly state-level data from covidtracking.com
#'
#' @return A data frame grouped by state. Contains weekly aggregated counts of positive tests, negative tests, death, and hospitalizations.
#' For those dates without negative incidence data in a given state, the sum of the positive cases over those dates
#' is added to the number of positive cases in the next date which does contain negative incidence. The t0 column for a given
#' state represents the day before covidtracking.com had data for that state.
#' @examples
#' dat <- get_weekly_state_dat()
#' @export

get_weekly_state_dat <- function(){

  # Load daily cumulative state counts
  dat <- pull_dat()

  # Data cleaning (remove columns, rename columns, arrange by state, etc)
  dat2 <- clean_dat(dat)

  # For stretches where negatives are NA, sum  the positive cases over that
  # stretch and let the next non-NA data "absorb" their contribution
  dat3 <- collapse_absent_negs(dat2)

  # Aggregate data into weekly intervals relative to the epiweek starting on 2020-03-01
  dat4 <- aggregate_weeks(dat3)

  # Add t0 == 1 row before first observation date
  dat_out <- get_t0(dat2, dat4)

  dat_out

}
