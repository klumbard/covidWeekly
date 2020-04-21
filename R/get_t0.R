#' Add row to weekly data to denote the day before first observation
#'
#' @param dat_daily A data frame of downloaded and cleaned state-level data from covidtracking.com
#' @param dat_weekly An aggregated weekly-level dataset output by other functions in this package.
#' @return
#' A data frame grouped by state. Contains weekly aggregated counts of positive tests, negative tests, death, and hospitalizations.
#' Data are aggregated into chunks of length \code{agg_interval} since \code{2020-03-01}. The first row in each state corresponds to the day before the first
#' reliable observations have been recorded in that state. If \code{absent_negs = "remove"}, this will be the first day on which the state reported both positive
#' and negative test counts. If \code{absent_negs = "remove"}, this will be the day before the first observation in the dataset, regardless of whether negative counts
#' are present.
#' @noRd
#' @examples
#' dat <- pull_dat()
#' dat2 <- clean_dat(dat)
#' dat3 <- collapse_absent_negs(dat2)
#' dat4 <- aggregate_weeks(dat3)
#' dat5 <- get_t0(dat, dat4)
get_t0 <- function(dat_weekly, absent_negs = "remove", agg_interval = NULL){

  nstate <- length(unique(dat_weekly$state))
  t0_frame <- data.frame(state = unique(dat_weekly$state),
                         epiWeek = numeric(nstate),
                         endPt = as.Date(1:nstate, origin=Sys.Date()),
                         pos = NA,
                         neg = NA,
                         hosp = NA,
                         tests = NA,
                         death = NA,
                         t0 = 1)


      for(i in 1:nrow(t0_frame)){
      this_state <- dplyr::filter(dat_weekly, state == t0_frame$state[i])[1, ]
      t0_frame$endPt[i] <- lubridate::ymd(this_state$endPt) - (agg_interval - 1)
      t0_frame$epiWeek[i] <- lubridate::epiweek(t0_frame$endPt[i]) + (lubridate::wday(t0_frame$endPt[i])/ 7) - 0.142

    }

    dat_out <-
      rbind.data.frame(t0_frame, as.data.frame(dat_weekly)) %>%
      dplyr::group_by(state) %>%
      dplyr::arrange(state, epiWeek)

    dat_out

}
