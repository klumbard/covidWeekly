#' Download daily state-level data from covidtracking.com
#'
#' @return A data frame containing recent daily state-level data on various covariates
#' @noRd
#' @examples
#' dat <- pull_dat()

pull_dat <- function() read.csv("https://covidtracking.com/api/v1/states/daily.csv",stringsAsFactors = FALSE)
