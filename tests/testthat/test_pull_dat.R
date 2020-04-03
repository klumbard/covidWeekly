context("Data pulling")
library(covidWeekly)

testthat::test_that("number of columns hasn't changed", {
  testthat::expect_equal(ncol(pull_dat()), 25)
})

testthat::test_that("column names haven't changed", {
  testthat::expect_equal(names(pull_dat()),
                         c("date", "state", "positive", "negative", "pending", "hospitalizedCurrently",
                           "hospitalizedCumulative", "inIcuCurrently", "inIcuCumulative",
                           "onVentilatorCurrently", "onVentilatorCumulative", "recovered",
                           "hash", "dateChecked", "death", "hospitalized", "total", "totalTestResults",
                           "posNeg", "fips", "deathIncrease", "hospitalizedIncrease", "negativeIncrease",
                           "positiveIncrease", "totalTestResultsIncrease")
  )
})

testthat::test_that("no states/territories are missing", {
  testthat::expect_equal(sort(unique(pull_dat()$state)),
                        c("AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE",
                          "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA",
                          "MA", "MD", "ME", "MI", "MN", "MO", "MP", "MS", "MT", "NC", "ND",
                          "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "PR",
                          "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI",
                          "WV", "WY")
  )
})
