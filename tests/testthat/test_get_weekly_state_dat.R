context("Final results")
library(covidWeekly)

testthat::test_that("final states column hasn't changed", {

  expect_equal(
    as.character(dplyr::filter(get_weekly_state_dat(),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$state),

    c("FL", "FL", "FL", "FL", "FL", "GA", "GA", "GA", "NY", "NY",
      "NY", "NY", "NY"))
})

testthat::test_that("final epiweekRelative column hasn't changed (remove negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "remove"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$epiweekRelative,

    c(0.285714285714286, 1, 2, 3, 4, 2.57142857142857, 3, 4, 0.285714285714286, 1, 2, 3, 4))
})

testthat::test_that("final epiweekRelative column hasn't changed (collapse negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "collapse"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$epiweekRelative,

    c(0.285714285714286, 1, 2, 3, 4, 0.285714285714286, 3, 4, 0.285714285714286, 1, 2, 3, 4))
})

testthat::test_that("final posWeekly column hasn't changed (remove negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "remove"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$posWeekly,

    c(NA, 14L, 63L, 581L, 3105L, NA, 310L, 1859L, NA, 76L, 448L,
      9832L, 41962L))
})


testthat::test_that("final posWeekly column hasn't changed (collapse negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "collapse"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$posWeekly,

    c(NA, 14L, 63L, 581L, 3105L, NA, 507L, 1859L, NA, 76L, 448L,
      9832L, 41962L))
})

testthat::test_that("final negWeekly column hasn't changed (remove negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "remove"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$negWeekly,

    c(NA, 100L, 378L, 6101L, 28787L, NA, 1246L, 6128L, NA, 92L, 2687L,
      32302L, 68535L))
})


testthat::test_that("final negWeekly column hasn't changed (collapse negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "collapse"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$negWeekly,

    c(NA, 100L, 378L, 6101L, 28787L, NA, 2557L, 6128L, NA, 92L, 2687L,
      32302L, 68535L))
})

testthat::test_that("final hospWeekly column hasn't changed (remove negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "remove"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$hospWeekly,

    c(NA, NA, NA, 158L, 368L, NA, NA, 617L, NA, NA, NA, 1603L, 8451L))
})


testthat::test_that("final hospWeekly column hasn't changed (collapse negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "collapse"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$hospWeekly,

    c(NA, NA, NA, 158L, 368L, NA, NA, 617L, NA, NA, NA, 1603L, 8451L))
})

testthat::test_that("final testsWeekly column hasn't changed (remove negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "remove"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$testsWeekly,

    c(NA, 114L, 441L, 6682L, 31892L, NA, 1556L, 7987L, NA, 168L,
      3135L, 42134L, 110497L))
})

testthat::test_that("final testsWeekly column hasn't changed (collapse negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "collapse"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$testsWeekly,

    c(NA, 114L, 441L, 6682L, 31892L, NA, 3064L, 7987L, NA, 168L,
      3135L, 42134L, 110497L))
})

testthat::test_that("final deathWeekly column hasn't changed (remove negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "remove"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$deathWeekly,

    c(NA, NA, 3L, 9L, 42L, NA, 13L, 55L, NA, NA, NA, 44L, 684L))
})


testthat::test_that("final deathWeekly column hasn't changed (collapse negs)", {

  expect_equal(
    dplyr::filter(get_weekly_state_dat(absent_negs = "collapse"),
                  state %in% c("FL", "NY", "GA") & epiweekRelative <= 4)$deathWeekly,

    c(NA, NA, 3L, 9L, 42L, NA, 14L, 55L, NA, NA, NA, 44L, 684L))
})
