#' Take raw daily state data, clean, and retain incidence
#'
#' @param dat A data frame of downloaded state-level data from covidtracking.com
#' @return A data frame grouped by state. Contains daily counts of positive tests, negative tests, death, and hospitalizations.
#' @noRd
#' @examples
#' dat <- pull_dat()
#' dat2 <- clean_dat(dat)
clean_dat <- function(dat){

  # remove American Samoa
  dat <- dplyr::filter(dat, !(state %in% c("AS", "MP", "VI", "GU")))

  # Make dates easier to work with and arrange by state and date
  dat_out <-
    dat %>%
    dplyr::mutate(date = lubridate::ymd(date)) %>%
    dplyr::arrange(state, date)


  day0 <- lubridate::ymd("2020-03-01")

  dat_out <-
    dat_out %>%
    dplyr::mutate(day = as.numeric(date - day0)) %>%  # Define days since Day 0
    dplyr::group_by(state) %>%
    dplyr::mutate(positiveIncrease = ifelse(dplyr::row_number()==1, positive, positiveIncrease)) %>% # covidtracking defines incidence as increase from the day before,
    dplyr::mutate(negativeIncrease = ifelse(dplyr::row_number()==1, negative, negativeIncrease)) %>% # which is undefined on the first day. these lines let give incidence for day 0 per-state
    dplyr::mutate(deathIncrease    = ifelse(dplyr::row_number()==1, death, deathIncrease)) %>%
    dplyr::mutate(hospitalizedIncrease = ifelse(dplyr::row_number()==1, hospitalized, hospitalizedIncrease)) %>%
    dplyr::mutate(totalTestResultsIncrease = ifelse(dplyr::row_number()==1, totalTestResults, totalTestResultsIncrease))

  # covidtracking defines increase from NA as 0..., for now I want that to be NA
  for(i in 1:nrow(dat_out)) {
    if(is.na(dat_out$positive[i])){dat_out$positiveIncrease[i] <- NA}
    if(is.na(dat_out$negative[i])){dat_out$negativeIncrease[i] <- NA}
    if(is.na(dat_out$death[i])){dat_out$deathIncrease[i] <- NA}
    if(is.na(dat_out$hospitalized[i])){dat_out$hospitalizedIncrease[i] <- NA}
    if(is.na(dat_out$totalTestResults[i])){dat_out$totalTestResultsIncrease[i] <- NA}
  }

  # Remove cumulative columns
  dat_out <-
    dat_out %>%
    dplyr::select(-positive, -negative, -death, -hospitalized,
           -totalTestResults, -dateChecked, -pending, -total)

  # Reorder columns
  dat_out <- dat_out[ , c("state", "date", "day", "positiveIncrease", "negativeIncrease",
                          "totalTestResultsIncrease", "hospitalizedIncrease", "deathIncrease")]

  # Rename columns
  names(dat_out) <- stringr::str_replace(names(dat_out), "Increase", "Today")
  names(dat_out) <- stringr::str_replace(names(dat_out), "positive", "pos")
  names(dat_out) <- stringr::str_replace(names(dat_out), "negative", "neg")
  names(dat_out) <- stringr::str_replace(names(dat_out), "hospitalized", "hosp")
  names(dat_out) <- stringr::str_replace(names(dat_out), "totalTestResults", "tests")


  dat_out

}
