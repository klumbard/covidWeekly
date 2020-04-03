#' Add row to weekly data to denote the day before first observation
#'
#' @param dat_daily A data frame of downloaded and cleaned state-level data from covidtracking.com
#' @param dat_weekly An aggregated weekly-level dataset output by other functions in this package.
#' @return
#' A data frame grouped by state. Contains weekly aggregated counts of positive tests, negative tests, death, and hospitalizations.
#' Time is measured in epidemiological weeks since 2020-03-01. The first row in each state corresponds to the day before the first
#' observation in that state.
#' @examples
#' dat <- pull_dat()
#' dat2 <- clean_dat(dat)
#' dat3 <- collapse_absent_negs(dat2)
#' dat4 <- aggregate_weeks(dat3)
#' dat5 <- get_t0(dat, dat4)
get_t0 <- function(dat_daily, dat_weekly){

  nstate <- length(unique(dat_daily$state))
  t0_frame <- data.frame(state = unique(dat_daily$state),
                           epiweekRelative = numeric(nstate),
                           posWeekly = NA,
                           negWeekly = NA,
                           hospWeekly = NA,
                           numtestsWeekly = NA,
                           deathWeekly = NA,
                           t0 = 1)

  for(i in 1:nrow(t0_frame)){
    this_state <- t0_frame$state[i]
    state_daily <-
      dat_daily %>%
      dplyr::filter(state == this_state) %>%
      dplyr::arrange(date) %>%
      dplyr::slice(1)

    this_date <- state_daily$date - 1
    t0_frame$epiweekRelative[i] <- as.numeric(this_date - lubridate::ymd("2020-03-01")) / 7

  }

  dat_out <-
    rbind(t0_frame, as.data.frame(dat_weekly)) %>%
    dplyr::group_by(state) %>%
    dplyr::arrange(state, epiweekRelative)

}
