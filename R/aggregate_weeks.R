#' Aggregate daily state-level data into week-level intervals
#'
#' @param dat A data frame of downloaded and cleaned state-level data from covidtracking.com, with absent negatives collapsed.
#' @return
#' A data frame grouped by state. Contains weekly aggregated counts of positive tests, negative tests, death, and hospitalizations.
#' Time is measured in epidemiological weeks since 2020-03-01.
#' @examples
#' dat <- pull_dat()
#' dat2 <- clean_dat(dat)
#' dat3 <- collapse_absent_negs(dat2)
#' dat4 <- aggregate_weeks(dat3)
aggregate_weeks <- function(dat){

  epiWeek0 <- lubridate::epiweek("2020-03-01")

  dat_out <-
    dat %>%
    dplyr::mutate(epiweek = lubridate::epiweek(date)) %>%
    dplyr::mutate(epiweekRelative = as.numeric(epiweek - epiWeek0 + 1)) %>% # Define weeks since week0
    dplyr::mutate(epiweekRelative = dplyr::if_else(epiweekRelative ==    # We want fractional epiweeks for the most recent week,
                                           max(epiweekRelative), # as we don't want to mistakenly count it as a whole week
                                           as.numeric(max(date) - lubridate::ymd("2020-03-01")) / 7, epiweekRelative)) %>%
    dplyr::group_by(state, epiweekRelative) %>%
    dplyr::summarize_at(dplyr::vars(posToday, negToday, hospToday,
                      numtestsToday, deathToday),
                 dplyr::funs(sum_or_allNA)) %>%
    dplyr::mutate(t0 = 0) %>% # Indicator column for day before first obs or not (t0==1 will be added later)
    dplyr::arrange(state, epiweekRelative)

  names(dat_out) <- stringr::str_replace(names(dat_out), "Today", "Weekly")

  dat_out

}
