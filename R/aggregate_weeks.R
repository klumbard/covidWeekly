#' Aggregate daily state-level data into week-level intervals
#'
#' @param dat A data frame of downloaded and cleaned state-level data from covidtracking.com, with absent negatives collapsed.
#' @param agg_interval A positive whole number giving the desired length of aggregation intervals.
#' @param t0 A date in the format "mm-dd-yyyy" which will serve as the "anchor" time from which we aggregate forwards
#' @return
#' A data frame grouped by state. Contains weekly aggregated counts of positive tests, negative tests, death, and hospitalizations.
#' Data are grouped chronologically into "chunks" of length \code{agg_interval} starting from \code{2020-03-01}.
#' @noRd
#' @examples
#' dat <- pull_dat()
#' dat2 <- clean_dat(dat)
#' dat3 <- collapse_absent_negs(dat2)
#' dat4 <- aggregate_weeks(dat3, agg_interval = 7)
aggregate_weeks <- function(dat, agg_interval, t0){

  dat_out <-
    dat %>%
    dplyr::filter(date >= lubridate::ymd(t0)) %>%
    dplyr::mutate(aggGroup = floor((lubridate::ymd(date) -
                                    lubridate::ymd(t0)) / agg_interval)) %>% # Group into intervals over which to aggregate
    dplyr::mutate(epiWeek = lubridate::epiweek(date) + (lubridate::wday(date)/ 7)) %>%
    dplyr::group_by(state, aggGroup) %>%
    dplyr::summarise(epiWeek = dplyr::last(epiWeek),
                     posToday = sum_or_allNA(posToday),
                     negToday = sum_or_allNA(negToday),
                     hospToday = sum_or_allNA(hospToday),
                     testsToday = sum_or_allNA(testsToday),
                     deathToday = sum_or_allNA(deathToday),
                     endPt = dplyr::last(lubridate::ymd(date))) %>%
    dplyr::mutate(t0 = 0) %>% # Indicator column for day before first obs or not (t0==1 will be added later)
    dplyr::arrange(state, epiWeek) %>%
    dplyr::select(-aggGroup) %>%
    dplyr::select(state, epiWeek, endPt, posToday, negToday, # rearrange columns
                  hospToday, testsToday, deathToday, t0)

  names(dat_out) <- stringr::str_remove(names(dat_out), "Today")

  dat_out

}
