

#' Generate summary statistics for profile stock data
#'
#' @param data A data frame, data frame extension (e.g. a tibble), or a lazy data frame (e.g. from dbplyr or dtplyr).
#' @param measurements character
#' @return tibble
#' @export
#'
#' @examples
summaryStats <- function(data, measurements=c("High", "Low", "Open", "Close")) {
  return(NULL)
}



#' Using moving average method to profile stock data
#'
#' @param data xts
#' @param window numeric
#' @param newColname character
#'
#' @return xts
#' @export
#'
#' @examples
#'
#'library(quantmod)
#' getSymbols("AAPL")
#' moving_avg_AAPL <- movingAverage(AAPL,300,paste("moveAverage", colnames(AAPL), sep="_"))
movingAverage <- function(data, window, newColname) {


}



exponentialSmoothing <- function() {

}


visMovingAverage <- function() {

}


visExpSmoothing <- function() {

}

