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



