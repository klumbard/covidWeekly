#' Sum positive cases over dates without negative data
#'
#' @param dat A data frame of downloaded and cleaned state-level data from covidtracking.com
#' @return
#' A data frame grouped by state. Contains daily counts of positive tests, negative tests, death, and hospitalizations. For dates
#' For those dates without negative incidence data in a given state, this function removes those rows and the next row chronologically,
#' since we don't know whether this row represents a catch-up count or not.
#' @noRd
#' @examples
#' dat <- pull_dat()
#' dat2 <- clean_dat(dat)
#' dat3 <- remove_absent_negs(dat2)

remove_absent_negs <- function(dat){

  dat_out <-
    dat %>%
    dplyr::group_by(state) %>%
    mutate(firstData = first(date)) %>%
    dplyr::filter(!is.na(negToday)) %>% # Remove all rows with NA negative test counts
    dplyr::filter(!(dplyr::row_number() == 1 & date != firstData)) %>% # Remove the row after that, too
    dplyr::ungroup() %>%
    dplyr::select(-firstData)

  dat_out

}

