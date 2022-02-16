test_that("optimisation", {
  example_data <-
    readRDS(system.file('extdata/test_data.rds', package = 'OptiCal'))



  results <- optimise(example_data, p = 0.6, quad = FALSE)

  expect_true(is.list(results))
  expect_true(length(results) == 3)
  expect_true(is.character(results$type))
  expect_true(is.numeric(results$score))
  expect_true(is.data.frame(results$data))
  expect_true(nrow(results$data) >= nrow(example_data) * 0.6)


})
