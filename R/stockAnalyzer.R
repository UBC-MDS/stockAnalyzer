

summaryStats <- function() {

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

#' Using exponential smoothing method to profile stock data
#'
#' @param data xts
#' @param newColname character
#' @param alpha numeric
#'
#' @return xts
#' @export
#'
#' @examples
#'
#'library(quantmod)
#' getSymbols("AAPL")
#' exp_smoothing_AAPL <- movingAverage(AAPL,paste("expsmoothing", colnames(AAPL), sep="_") , 0.3)
exponentialSmoothing <- function() {

}


visMovingAverage <- function() {

}


visExpSmoothing <- function() {

}

