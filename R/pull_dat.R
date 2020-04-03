#' Download daily state-level data from covidtracking.com
#'
#' @return A data frame containing recent daily state-level data on various covariates
#' @examples
#' dat <- pull_dat()

pull_dat <- function() read.csv("http://covidtracking.com/api/states/daily.csv",stringsAsFactors = FALSE)
