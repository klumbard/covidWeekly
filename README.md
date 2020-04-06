# covidWeekly

## Download daily state-level data from covidtracking.com and aggregate to weekly

The **covidWeekly** R package is a utility package that takes the state-level data from [covidtracking.com](https://covidtracking.com), makes various manipulations to the data, and aggregates the daily data into weekly intervals. The only function a user will likely need to use is the main wrapper function, `get_weekly_state_dat()`. The function currently takes no arguments.

## Getting Started
This package may be installed directly from GitHub using the devtools package:
```
library(devtools)
install_github("klumbard/covidWeekly") 
library(covidWeekly)
weekly_dat <- get_weekly_state_dat()
```

## Data Manipulation and Important Assumptions
The important features of our data manipulations to know are as follows:
1. When data were first being collected, some states only reported positive case counts and not negatives. In some cases, on the day when that state started reporting negatives, the negative count for that day is very large, which leads us to believe that that number actually includes the negative tests from the previous days on which they were unreported. But this doesn't seem to **always** be the case. Because of the ambiguity, we provide two options for dealing with absent negatives: removing (default) and collapsing. If they are removed with the argument `absent_negs = "remove"`, all rows in which no negative count is reported are removed. Because we don't know whether the first day on which negatives *are* reported in a given state also contains a "catchup" count which includes counts from the previous days, we don't consider the data reliable on this day and thus we remove this row as well. If the argument `absent_negs = "collapse"` is insteads chosen, over these periods of missing negatives, we sum up the number of positive cases and add it to the positive count on the next date at which full data were reported.

2. Time is measured in terms of "epidemiological weeks" since the epidemiological week started on 2020-03-01 and is encoded by the column `epiweekRelative`. For each state, we include a row in which `t0 == 1` (time zero) which indicates the day before each state started reporting **reliable** data. If the argument `absent_negs` is set to `"remove"`, `t0` will be the first day on which positive and negatives were reported in that state. If the argument is instead set to `collapse`, `t0` will be the day before the first observation of that state in the dataset, whether or not negative counts were reported from the beginning. This `t0` row and the last row in any given state are the only ones which should have fractional parts to their `epiweekRelative` value; the first row because the first observation in any given state can occur in the middle of a week, and the last row because unless the data are pulled on Sunday, the most recent data don't comprise a full epidemiological week.

3. For now, we are removing data from American Samoa (AS), the Northern Mariana Islands (MR), the Virgin Islands (VI), and Guam (GU) because their data are too sparse to be usable.
