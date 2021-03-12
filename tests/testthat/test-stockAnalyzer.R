test_that("summaryStats() returns summary statistics of given xts file", {
  # Wrong type of input
  data_1 <- dplyr::as_tibble(iris)
  expect_error(summaryStats(data_1),
               "Your input data should be in Extensible Time Series (xts) format.",
               fixed = TRUE)

  # measurement not in column names
  data_2 <- xts::xts(x=1:10, order.by=Sys.Date()-1:10)
  expect_error(summaryStats(data_2, measurements = c("Wrong_column_name")),
               "Your specified measurement 'Wrong_column_name' is not a column name of the data. Please double check the column names in data.",
               fixed = TRUE)

  # Non-numeric data
  data_3 <- xts::xts(x=c("a", "b"), order.by=Sys.Date()-1:2)
  colnames(data_3) <- c("col1")
  expect_error(summaryStats(data_3),
               "Data in column 'col1' of your input data cannot be converted to numeric format.",
               fixed = TRUE)

  # NA test
  data_4 <- xts::xts(x=c(1, 2, NA), order.by=Sys.Date()-1:3)
  colnames(data_4) <- c("col1")
  expect_equal(class(summaryStats(data_4))[1], "tbl_df")
  expect_equal(ncol(summaryStats(data_4)), 6)
  expect_equal(summaryStats(data_4)$mean, 1.5)
  expect_equal(is.na(summaryStats(data_4)$return), TRUE)

  # normal test
  data_5 <- xts::xts(cbind(x=1:5, y=5:1, z=2:6), order.by=Sys.Date()-1:5)
  expect_equal(class(summaryStats(data_5))[1], "tbl_df")
  expect_equal(ncol(summaryStats(data_5)), 6)
  expect_equal(nrow(summaryStats(data_5)), 3)
  expect_equal(nrow(summaryStats(data_5, measurements=c("x", "y"))), 2)
  expect_equal(summaryStats(data_5, measurements=c("x", "y"))$return[1], -0.8)
}
)

test_that("visMovingAverage() returns ggplot of original and moving average data", {
  data <- xts::xts(cbind(x=1:5, y=5:1, z=2:6), order.by=Sys.Date()-1:5)
  vis <- visMovingAverage(data, 2, name="y")

  expect_equal(length(vis$layers), 2)
  expect_equal(rlang::as_string(rlang::get_expr(vis$layers[[1]]$mapping$x)), "Date")
  expect_equal(rlang::as_string(rlang::get_expr(vis$layers[[1]]$mapping$y)), "value")
  expect_equal(rlang::as_string(rlang::get_expr(vis$layers[[2]]$mapping$x)), "Date")
  expect_equal(rlang::as_string(rlang::get_expr(vis$layers[[2]]$mapping$y)), "value")
  expect_equal(class(vis$layers[[1]]$geom)[1], "GeomLine")
  expect_equal(class(vis$layers[[2]]$geom)[1], "GeomLine")
}
)
