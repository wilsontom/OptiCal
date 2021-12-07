#' Linear Regression Optimisation
#'
#' @param p_area a list of calibration data
#' @return a list of three elements
#' @keywords internal

linear_opt <- function(p_area)
{
  all_linear_models <- purrr::map(p_area, ~ {
    lm(concentration ~ area, data = .)
  })


  lmrsq <- purrr::map_dbl(all_linear_models, ~ {
    summary(.)$r.squared
  })

  lmpred <- purrr::map(all_linear_models, predict)

  lmacc <- list()
  for (k in seq_along(lmpred)) {
    lmacc[[k]] <-
      abs(lmpred[[k]] - p_area[[k]]$concentration) / p_area[[k]]$concentration
  }

  lmcc_me <- purrr::map_dbl(lmacc, mean)
  err <- 1 - lmcc_me / max(lmcc_me)


  step_range <- purrr::map(p_area, ~ {
    diff(.$concentration)
  })

  step_range_me <- purrr::map_dbl(step_range, median)

  step_range_rel <- (step_range_me / max(step_range_me)) / 2

  OPTICAL_SCORE <- list()
  for (i in seq_along(lmrsq)) {
    OPTICAL_SCORE[[i]] <-
      weighted.mean(c(lmrsq[i], err[i], step_range_rel[i]))
  }


  OPTICAL_SCORE <- unlist(OPTICAL_SCORE)


  popt <- which.max(OPTICAL_SCORE)

  return(list(
    type = 'linear',
    score = max(OPTICAL_SCORE),
    data = p_area[[popt]]
  ))

}
