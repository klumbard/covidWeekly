context("Final results")
library(covidWeekly)

testthat::test_that("final states column hasn't changed", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$state,

    structure(c(10L, 10L, 10L, 10L, 10L, 11L, 11L, 11L, 36L, 36L,
                36L, 36L, 36L), .Label = c("AK", "AL", "AR", "AZ", "CA", "CO",
                                           "CT", "DC", "DE", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN",
                                           "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT",
                                           "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR",
                                           "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT",
                                           "WA", "WI", "WV", "WY"), class = "factor"))
})

testthat::test_that("final epiweekRelative column hasn't changed", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$epiweekRelative,

    c(0.285714285714286, 1, 2, 3, 4, 0.285714285714286, 3, 4, 0.285714285714286, 1, 2, 3, 4))
})

testthat::test_that("final posWeekly column hasn't changed", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$posWeekly,

    c(NA, 14L, 63L, 581L, 3105L, NA, 507L, 1859L, NA, 76L, 448L,
      9832L, 41962L))
})

testthat::test_that("final negWeekly column hasn't changed", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$negWeekly,

    c(NA, 100L, 378L, 6101L, 28787L, NA, 2557L, 6128L, NA, 92L, 2687L,
      32302L, 68535L))
})

testthat::test_that("final hospWeekly column hasn't changed", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$hospWeekly,

    c(NA, NA, NA, 158L, 368L, NA, NA, 617L, NA, NA, NA, 1603L, 8451L))
})

testthat::test_that("final hospWeekly column hasn't changed", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$numtestsWeekly,

    c(NA, 114L, 441L, 6682L, 31892L, NA, 3064L, 7987L, NA, 168L,
      3135L, 42134L, 110497L))
})

testthat::test_that("final deathWeekly column hasn't changed", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$deathWeekly,

    c(NA, NA, 3L, 9L, 42L, NA, 14L, 55L, NA, NA, NA, 44L, 684L))
})
