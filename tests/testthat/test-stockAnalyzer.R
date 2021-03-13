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



test_that("movingAverage() returns a xts object with moving average method", {

  # Wrong input type for data
  data_0 <- dplyr::as_tibble(iris)
  expect_error(movingAverage(data_0),
               "Your input data should be in Extensible Time Series (xts) format.",
               fixed = TRUE)


  # Wrong input type for window
  data_1 <- xts::xts(x=1:10, order.by=Sys.Date()-1:10)
  expect_error(movingAverage(data_1, "a"),
               "Your input window should be numeric.",
               fixed = TRUE)

  # Non-numeric data

  data_2 <- xts::xts(x=c("a", "b"), order.by=Sys.Date()-1:2)
  colnames(data_2) <- c("col1")
  expect_error(movingAverage(data_2, 1, paste("movingAverage", colnames(data_2), sep="_")[,"col1"]),
               "Your input data should be numeric",
               fixed = TRUE)

  # NA test
  data_3 <- xts::xts(x=c(1, 2, NA), order.by=Sys.Date()-1:3)
  colnames(data_3) <- c("col_1")
  expect_equal(class(movingAverage(data_3, window = 1, paste("movingAverage", colnames(data_3), sep="_")))[1], "xts")
  expect_equal(ncol(movingAverage(data_3, window = 1, paste("movingAverage", colnames(data_3), sep="_"))), 1)
  expect_equal(nrow(movingAverage(data_3, window = 1, paste("movingAverage", colnames(data_3), sep="_"))), 3)
  expect_equal(sum(is.na(movingAverage(data_3, window = 1, paste("movingAverage", colnames(data_3), sep="_")))),1)

  # normal test
  data_4 <- xts::xts(cbind(x=1:5, y=5:1, z=2:6), order.by=Sys.Date()-1:5)
  expect_true(class(movingAverage(data_4, window = 2, paste("movingAverage", colnames(data_4), sep="_")))[1] == "xts")
  expect_true(ncol(movingAverage(data_4, window = 2, paste("movingAverage", colnames(data_4), sep="_"))) == 3)
  expect_true(nrow(movingAverage(data_4, window = 2, paste("movingAverage", colnames(data_4), sep="_"))) == 5)
  expect_true(colnames(movingAverage(data_4, 2,  paste("movingAverage", colnames(data_4), sep="_")))[1]=="movingAverage_x")
  expect_true(colnames(movingAverage(data_4, 2,  paste("movingAverage", colnames(data_4), sep="_")))[2]=="movingAverage_y")
  expect_true(colnames(movingAverage(data_4, 2,  paste("movingAverage", colnames(data_4), sep="_")))[3]=="movingAverage_z")
  expect_true(class(zoo::index(movingAverage(data_4, 2,  paste("movingAverage", colnames(data_4), sep="_"))))=="Date")

}
)



test_that("exponentialSmoothing() returns a xts object with exponential Smoothing", {
  
  # normal test
  data <- xts::xts(cbind(x=seq(5,1) , y=seq(10,2,-2), z=seq(15,3,-3)), order.by=Sys.Date()-1:5)
  pred <- exponentialSmoothing (data, paste("exponentialSmoothing", colnames(data_4), sep="_"), 0.3)
  expect_true(class(pred )[1] == "xts")
  expect_true(ncol( pred) == 3)
  expect_true(nrow( pred) == 5)
  expect_true(colnames(pred )[1]=="exponentialSmoothing_x")
  expect_true(colnames( pred)[2]=="exponentialSmoothing_y")
  expect_true(colnames(pred )[3]=="exponentialSmoothing_z")
  expect_true(class(zoo::index(pred ))=="Date")
  expect_equal( round(pred[5][[1]],4) , 3.2269 ) 
  expect_equal( round(pred[5][[2]],4) , 6.4538  ) 
  expect_equal( round(pred[5][[3]],4) , 9.6807 ) 
  
}
)




test_that("visMovingAverage() should return ggplot of original and moving average data", {
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

test_that("visExpSmoothing() should return ggplot of original and exponential smoothing data", {
  data <- xts::xts(cbind(x=1:5, y=5:1, z=2:6), order.by=Sys.Date()-1:5)
  vis2 <- visExpSmoothing(data, 0.3, name="y")

  expect_equal(length(vis2$layers), 2)
  expect_equal(rlang::as_string(rlang::get_expr(vis2$layers[[1]]$mapping$x)), "Date")
  expect_equal(rlang::as_string(rlang::get_expr(vis2$layers[[1]]$mapping$y)), "value")
  expect_equal(rlang::as_string(rlang::get_expr(vis2$layers[[2]]$mapping$x)), "Date")
  expect_equal(rlang::as_string(rlang::get_expr(vis2$layers[[2]]$mapping$y)), "value")
  expect_equal(class(vis2$layers[[1]]$geom)[1], "GeomLine")
  expect_equal(class(vis2$layers[[2]]$geom)[1], "GeomLine")
}
)
