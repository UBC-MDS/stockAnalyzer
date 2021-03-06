#' Generate summary statistics for profile stock data
#'
#' @param data xts a time series object
#' @param measurements character
#' @return tibble
#' @export
#'
#' @examples
#' quantmod::getSymbols("AAPL")
#' summary_stats_AAPL <- summaryStats(AAPL)
#'
summaryStats <-
  function(data,
           measurements = colnames(data)) {
    if (class(data)[1] != "xts") {
      stop('Your input data should be in Extensible Time Series (xts) format.')
    }
    stats <-
      list(vector(), vector(), vector(), vector(), vector(), vector())
    names(stats) <-
      c("measurement", "mean", "min", "max", "volatility", "return")
    for (measurement in measurements) {
      if (measurement %in% colnames(data) == FALSE) {
        stop(
          paste0(
            "Your specified measurement '",
            measurement,
            "' is not a column name of the data. Please double check the column names in data."
          )
        )
      }
      x <- matrix(0, nrow(data) , ncol(data))
      for (j in seq(1, dim(data)[2])) {
        for (i in seq(1, dim(data)[1])) {
          x[i, j] <- data[i, j]
        }
      }
      colnames(x) <- colnames(data)
      data_measurement <- x[, measurement]
      data_measurement <- tryCatch({
        as.numeric(data_measurement)
      },
      warning = function(w) {
        stop(
          paste0(
            "Data in column '",
            measurement,
            "' of your input data cannot be converted to numeric format."
          )
        )
      })
      stats[["measurement"]] <-
        append(stats[["measurement"]], measurement)
      stats[["mean"]] <-
        append(stats[["mean"]], mean(data_measurement, na.rm = TRUE))
      stats[["min"]] <-
        append(stats[["min"]], min(data_measurement, na.rm = TRUE))
      stats[["max"]] <-
        append(stats[["max"]], max(data_measurement, na.rm = TRUE))
      stats[["volatility"]] <-
        append(stats[["volatility"]], stats::sd(data_measurement, na.rm =
                                                  TRUE))
      stats[["return"]] <-
        append(stats[["return"]],
               (utils::tail(data_measurement, n = 1) - data_measurement[1]) / data_measurement[1])
    }
    dplyr::as_tibble(stats)
  }


#' Using moving average method to profile stock data
#'
#' @param data xts a time series object
#' @param window numeric
#' @param newColname character
#'
#' @return xts a time series object
#' @export
#'
#' @examples
#' quantmod::getSymbols("AAPL")
#' moving_avg_AAPL <- movingAverage(AAPL, 300, paste("movingAverage", colnames(AAPL), sep="_"))
movingAverage <- function(data, window, newColname) {
  if (class(data)[1] != "xts") {
    stop('Your input data should be in Extensible Time Series (xts) format.')
  }

  if (class(window) != "numeric") {
    stop('Your input window should be numeric.')
  }

  for (col in colnames(data)) {
    if (is.numeric(data[,col]) != TRUE) {
      stop('Your input data should be numeric.')
    }
  }

  x <- matrix(0, nrow(data) , ncol(data))

  for (j in seq(1, dim(data)[2])) {
    for (i in seq(1, window - 1)) {
      x[i, j] <- data[i, j]
    }

    for (i in seq(window, dim(data)[1])) {
      x[i, j] <- mean(data[(i - window + 1):i, j], na.rm  = TRUE)
    }
  }

  colnames(x) <- newColname
  xts::xts(x, zoo::index(data))
}


#' Using exponential smoothing method to profile stock data
#'
#' @param data xts a time series object
#' @param newColname character
#' @param alpha numeric
#'
#' @return xts
#' @export
#'
#' @examples
#' options("getSymbols.warning4.0"=FALSE)
#' quantmod::getSymbols("AAPL")
#' exp_smoothing_AAPL <- exponentialSmoothing(
#'     AAPL,paste("expsmoothing", colnames(AAPL), sep="_") , 0.3
#'     )
exponentialSmoothing <- function(data, newColname, alpha=0.3) {

  if (class(data)[1] != "xts") {
    stop('Your input data should be in Extensible Time Series (xts) format.')
  }

  if (class(alpha) != "numeric") {
    stop('Your alpha should be numeric between 0 and 1.')
  }

  if (alpha >1 || alpha <0) {
    stop('Your alpha should be numeric between 0 and 1.')
  }

  for (col in colnames(data)) {
    if (is.numeric(data[,col]) != TRUE) {
      stop('Your input data should be numeric.')
    }
  }


  x <- matrix(0, nrow(data) , ncol(data))

  for (j in seq(1, ncol(data))) {
    St_prev <- data[1,j]

    for (i in seq(1, nrow(data))) {
      yt <- data[i,j]
      St <- as.numeric(alpha * yt) + as.numeric(St_prev * (1 - alpha))
      x[i,j] <- St
      St_prev <- St
    }
  }

  colnames(x) <- newColname
  xts::xts(x, zoo::index(data))
}

#' Visualizing the trend of the stock by using moving average method
#'
#' @param data xts a time series object
#' @param window A numeric vector of the size of the window (number of days) used in moving average calculation
#' @param name a character vector of the name of the column to be used in moving average calculation
#'
#' @return A ggplot line plot of specific stock's historical prices and moving average prices
#' @export
#'
#' @examples
#' quantmod::getSymbols("AAPL")
#' visMA_AAPL <- visMovingAverage(AAPL, 300, 'AAPL.Close')
visMovingAverage <- function(data, window, name) {
  if (name %in% colnames(data) == FALSE) {
    stop("Your input name does not match with the dataframe column name! Please enter valid column name!")
  }
  df_avgs <- movingAverage(data, window, paste("movingAverage", colnames(data), sep="_"))

  df_avgs <-
    tibble::tibble(Date = as.Date(zoo::index(df_avgs)) , value = as.numeric(df_avgs[, paste0("movingAverage_", name)]))

  data <-
    tibble::tibble(Date = as.Date(zoo::index(data)) , value = as.numeric(data[, name]))

  sma_plot <- ggplot2::ggplot(df_avgs) +
    ggplot2::geom_line(ggplot2::aes_string(x = "Date", y = "value"), color = "#0abab5") +
    ggplot2::geom_line(data, mapping = ggplot2::aes_string(x = "Date", y = "value"), color = "#00008b") +
    ggplot2::ggtitle("Stock Price History with Simple Moving Average") +
    ggplot2::ylab("Price")

  sma_plot
}



#' Using the trend of the stock by using exponential smoothing method
#'
#' @param data xts a time series object
#' @param alpha A numeric vector of the smoothing parameter which defines the weighting. It should be between 0 and 1
#' @param name a character vector of the name of the column to be used in moving average calculation
#'
#' @return ggplot line plot of specific stock's historical prices and exponentially smoothed prices
#' @export
#'
#' @examples
#' quantmod::getSymbols("AAPL")
#' visES_AAPL <- visExpSmoothing(AAPL, 0.3, 'AAPL.Close')
visExpSmoothing <- function(data, alpha, name) {
  if (name %in% colnames(data) == FALSE) {
    stop("Your input name does not match with the dataframe column name! Please enter valid column name!")
  }
  df_smoothed <- exponentialSmoothing(data, paste("expsmoothing", colnames(data), sep="_"), alpha)

  df_smoothed <-
    tibble::tibble(Date = as.Date(zoo::index(df_smoothed)) , value = as.numeric(df_smoothed[, paste0("expsmoothing_", name)]))

  data <-
    tibble::tibble(Date = as.Date(zoo::index(data)) , value = as.numeric(data[, name]))

  expsm_plot <- ggplot2::ggplot(df_smoothed) +
    ggplot2::geom_line(ggplot2::aes_string(x = "Date", y = "value"), color = "#0abab5") +
    ggplot2::geom_line(data, mapping = ggplot2::aes_string(x = "Date", y = "value"), color = "#00008b") +
    ggplot2::ggtitle("Stock Price History with Exponential Smoothing") +
    ggplot2::ylab("Price")

  expsm_plot
}
