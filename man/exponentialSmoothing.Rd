% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stockAnalyzer.R
\name{exponentialSmoothing}
\alias{exponentialSmoothing}
\title{Using exponential smoothing method to profile stock data}
\usage{
exponentialSmoothing(data, newColname, alpha = 0.3)
}
\arguments{
\item{data}{xts a time series object}

\item{newColname}{character}

\item{alpha}{numeric}
}
\value{
xts
}
\description{
Using exponential smoothing method to profile stock data
}
\examples{
options("getSymbols.warning4.0"=FALSE)
quantmod::getSymbols("AAPL")
exp_smoothing_AAPL <- exponentialSmoothing(
    AAPL,paste("expsmoothing", colnames(AAPL), sep="_") , 0.3
    )
}
