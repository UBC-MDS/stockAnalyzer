
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stockAnalyzer

<!-- badges: start -->

<!-- badges: end -->

This is an R package that provides basic time series modelling
functionalities to analyze historical stock prices. Investment in the
stock market requires not only knowledge about the listed companies, but
also basic summary statistics and modellings of individual stock prices.
Given time-series stock price data, this package provides key summary
statistics, applies moving average and exponential smoothing models to
the data, and visualizes in-sample moving average as well as exponential
smoothing fits. A convenient use case for this package is to combine it
with the `quantmod` library, which can provide well-formated stock price
data from Yahoo Finance dataset with customized date range setting. \#\#
Installation

You can install the released version of stockAnalyzer from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("stockAnalyzer")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("UBC-MDS/stockAnalyzer")
```

## Features

The package contains the following five functions:

  - `summaryStats`

This function calculates summary statistics including mean price,
minimum price, maximum price, volatility and return rate based on daily
historical stock prices. Users can specify lengths of time spans to
calculate summary statistics on, and what kind of stock price
measurement to use.

  - `movingAverage`

This function applies the moving average model to all measurements of
stock price and returns a pandas dataframe containing in-sample fitted
values. Users can specify the length of moving average windows (unit:
days).

  - `exponentialSmoothing`

This function performs exponential smoothing on historical stock price
time series data. Users can specify the `alpha` parameter (which defines
the weighting, ranging between 0 and 1) for smoothing.

  - `visMovingAverage`

This function creates a line chart showing the raw historical data and
fitted data using the moving average method. Users are able to specify
the dataframe used, the column of choice (such as ‘Close’, ‘Adj Close’)
for moving average calculation, and the length of moving average window
(unit: days).

  - `visExpSmoothing`

This function creates a line chart showing the raw historical data and
fitted data using the exponential smoothing method. Users are able to
specify the dataframe used, the column of choice (such as ‘Close’, ‘Adj
Close’) for exponential smoothing calculation, and the `alpha` parameter
(which defines the weighting, ranging between 0 and 1) for smoothing.

## Example

This is a basic example which shows how to generate summary statistics
and conduct moving average modelling:

``` r
# Download stock price data
library(quantmod)
#> Loading required package: xts
#> Loading required package: zoo
#> 
#> Attaching package: 'zoo'
#> The following objects are masked from 'package:base':
#> 
#>     as.Date, as.Date.numeric
#> Loading required package: TTR
#> Registered S3 method overwritten by 'quantmod':
#>   method            from
#>   as.zoo.data.frame zoo
getSymbols("AAPL")
#> 'getSymbols' currently uses auto.assign=TRUE by default, but will
#> use auto.assign=FALSE in 0.5-0. You will still be able to use
#> 'loadSymbols' to automatically load data. getOption("getSymbols.env")
#> and getOption("getSymbols.auto.assign") will still be checked for
#> alternate defaults.
#> 
#> This message is shown once per session and may be disabled by setting 
#> options("getSymbols.warning4.0"=FALSE). See ?getSymbols for details.
#> [1] "AAPL"

library(stockAnalyzer)
summary_stats_AAPL <- summaryStats(AAPL, measurements=c("High", "Low", "Open", "Close"))
moving_avg_AAPL <- movingAverage(AAPL,300,paste("moveAverage", colnames(AAPL), sep="_"))
```

## R Ecosystem

There are a number of libraries in the R ecosystem that provide
functionalities to analyze time series data. For example, `Tidyverse`
has comprehensive functionalities for basic summary statistics.
Libraries including `data.table`, `smooth` provide functions to
calculate moving average. Libraries including `smooth` and `forecast`
both provide functions to conduct exponential smoothing. `ggplot2` is
most widely used for visualizations.

In terms of financial data analysis, there are also a wide range of
packages. Widely used ones include
[`RQuantLib`](https://cran.r-project.org/web/packages/RQuantLib/index.html),
[‘quantmod’](https://cran.r-project.org/web/packages/quantmod/index.html).
