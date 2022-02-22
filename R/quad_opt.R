#' Quadratic Regression Optimisation
#'
#' @param p_area a list of calibration data
#' @return a list of three elements
#' @keywords internal

quad_opt <- function(p_area)
{
  all_quad_models <- purrr::map(p_area, ~ {
    lm(concentration ~ area + I(area ^ 2), data = .)
  })


  qursq <- purrr::map_dbl(all_quad_models, ~ {
    summary(.)$r.squared
  })

  qupred <- purrr::map(all_quad_models, predict)

  quacc <- list()
  for (k in seq_along(qupred)) {
    quacc[[k]] <-
      abs(qupred[[k]] - p_area[[k]]$concentration) / p_area[[k]]$concentration
  }

  qucc_me <- purrr::map_dbl(quacc, mean)
  err <- 1 - qucc_me / max(qucc_me)


  step_range <- purrr::map(p_area, ~ {
    diff(.$concentration)
  })

  step_range_me <- purrr::map_dbl(step_range, median)

  step_range_rel <- log(((step_range_me / max(step_range_me))))


  OPTICAL_SCORE <- list()
  for (i in seq_along(qursq)) {
    OPTICAL_SCORE[[i]] <-
      weighted.mean(c(qursq[i], err[i])) #, step_range_rel[i]))
  }

  OPTICAL_SCORE <- unlist(OPTICAL_SCORE)


  popt <- which.max(OPTICAL_SCORE)

  return(list(
    type = 'quadratic',
    score = max(OPTICAL_SCORE),
    data = p_area[[popt]]
  ))

}
