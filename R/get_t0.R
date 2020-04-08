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
get_t0 <- function(dat_daily, dat_weekly, absent_negs = "remove"){

  nstate <- length(unique(dat_daily$state))
  t0_frame <- data.frame(state = unique(dat_daily$state),
                         epiWeek = numeric(nstate),
                         endPt = as.Date(1:nstate, origin=Sys.Date()),
                         pos = NA,
                         neg = NA,
                         hosp = NA,
                         tests = NA,
                         death = NA,
                         t0 = 1)

  if(absent_negs == "remove"){
    for(i in 1:nrow(t0_frame)){
      this_state <- t0_frame$state[i]
      state_daily <-
        dat_daily %>%
        dplyr::filter(state == this_state) %>%
        dplyr::arrange(date) %>%
        dplyr::mutate(firstData = dplyr::first(date)) %>%
        dplyr::filter(!is.na(negToday)) %>% # Remove all rows with NA negative test counts
        dplyr::filter(!(dplyr::row_number() == 1 & date != firstData)) %>% # Remove the row after that, too
        dplyr::slice(1)

      this_date <- lubridate::ymd(state_daily$date[1] - 1)
      t0_frame$epiWeek[i] <- lubridate::epiweek(this_date) + (lubridate::wday(this_date)/ 7)
      t0_frame$endPt[i] <- lubridate::ymd(this_date)
    }

    dat_out <-
      rbind.data.frame(t0_frame, as.data.frame(dat_weekly)) %>%
      dplyr::group_by(state) %>%
      dplyr::arrange(state, epiWeek)

    dat_out

  } else if(absent_negs == "collapse"){

    for(i in 1:nrow(t0_frame)){
      this_state <- t0_frame$state[i]
      state_daily <-
        dat_daily %>%
        dplyr::filter(state == this_state) %>%
        dplyr::arrange(date) %>%
        dplyr::slice(1)

      this_date <- state_daily$date - 1
      t0_frame$epiWeek[i] <- lubridate::epiweek(this_date) + (lubridate::wday(this_date)/ 7)
      t0_frame$endPt[i] <- lubridate::ymd(this_date)
    }


    dat_out <-
      rbind.data.frame(t0_frame, as.data.frame(dat_weekly)) %>%
      dplyr::group_by(state) %>%
      dplyr::arrange(state, epiWeek)
  }

  dat_out

}
