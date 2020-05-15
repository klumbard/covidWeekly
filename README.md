# covidWeekly

## Download daily state-level data from covidtracking.com and aggregate over time-chunks

The **covidWeekly** R package is a utility package that takes the state-level data from [covidtracking.com](https://covidtracking.com), makes various manipulations to the data, and aggregates the daily data into intervals of user-defined length. The only function a user will likely need to use is the main wrapper function, `get_state_dat()`. The function currently takes arguments `absent_negs`, which controls what to do with rows that are missing negative counts, `agg_interval`, which controls the length of the aggregation "chunks" into which we collect the data, and `t0` which defines the start date of the first aggregation interval.

## Getting Started
This package may be installed directly from GitHub using the devtools package:
```
library(devtools)
install_github("klumbard/covidWeekly") 
library(covidWeekly)
weekly_dat <- get_state_dat(agg_interval = 7, t0 = "2020-03-15")
```

## Data Manipulation and Important Assumptions
The important features of our data manipulations to know are as follows:
1. When data were first being collected, some states only reported positive case counts and not negatives. In some cases, on the day when that state started reporting negatives, the negative count for that day is very large, which leads us to believe that that number actually includes the negative tests from the previous days on which they were unreported. But this doesn't seem to **always** be the case. Because of the ambiguity, we provide two options for dealing with absent negatives: removing (default) and collapsing. If they are removed with the argument `absent_negs = "remove"`, all rows in which no negative count is reported are removed. Because we don't know whether the first day on which negatives *are* reported in a given state also contains a "catchup" count which includes counts from the previous days, we don't consider the data reliable on this day and thus we remove this row as well. If the argument `absent_negs = "collapse"` is insteads chosen, over these periods of missing negatives, we sum up the number of positive cases and add it to the positive count on the next date at which full data were reported.

2. Time is measured in terms of "epidemiological weeks". For each state, we include a row in which `t0 == 1` (time zero) which indicates the user-defined start date of the first aggregation interval.

3. Aggregation is done in chunks of length `agg_interval`, starting counting from `t0`. For example, if a user specified the argument `agg_interval = 3`, and `t0 = "2020-03-15"`, "chunk" 1 would consist of data from 1 March, 2 March, and 3 March. "Chunk" 2 would consist of data from 4 March, 5 March, 6 March, etc. These are the "chunks"" that are then summed over to get the aggregated results that are returned to the user.  The `epiweek` column and `endPt` column both repreasent the right endpoint of the aggregation interval for that row; `epiweek` in fractional epidemiological weeks, and `endPt` raw date values.

4. For now, we are removing data from American Samoa (AS), the Northern Mariana Islands (MR), the Virgin Islands (VI), and Guam (GU) because their data are too sparse to be usable.
