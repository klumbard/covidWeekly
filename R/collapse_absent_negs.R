#' Sum positive cases over dates without negative data
#'
#' @param dat A data frame of downloaded and cleaned state-level data from covidtracking.com
#' @return
#' A data frame grouped by state. Contains daily counts of positive tests, negative tests, death, and hospitalizations. For dates
#' For those dates without negative incidence data in a given state, this function sums up the positive cases over those dates
#' and adds this sum to the number of positive cases in the next date which does contain negative incidence.
#' @noRd
#' @examples
#' dat <- pull_dat()
#' dat2 <- clean_dat(dat)
#' dat3 <- collapse_absent_negs(dat2)

collapse_absent_negs <- function(dat){

  dat_out <-
    dat %>%
    dplyr::group_by(state, idx = rev(cumsum(rev(!is.na(negToday))))) %>% # create new grouping variable that clusters data in "runs" of NAs along with the next row w/ observed data
    dplyr::mutate(posToday = sum_or_allNA(posToday)) %>% # sum over groups defined above
    dplyr::mutate(hospToday = sum_or_allNA(hospToday)) %>% # sum over groups defined above
    dplyr::mutate(numtestsToday = sum_or_allNA(numtestsToday)) %>% # sum over groups defined above
    dplyr::mutate(deathToday = sum_or_allNA(deathToday)) %>% # sum over groups defined above
    dplyr::ungroup() %>%
    dplyr::filter(!is.na(negToday)) %>% # remove rows that were summed over
    dplyr::select(-idx)

  dat_out

}

