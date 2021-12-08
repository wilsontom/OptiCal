#' Optimise Calibration Series
#'
#' @param calibration_data a `data.frame` or `tibble` of calibration data. The data should have two columns named, `area` and `concentration`.
#' @param p a numeric value (between 0 and 1) of the minimum percentage of calibration observations to utilise
#' @param quad logical; if `TRUE` then quadratic regression is also included alongside linear regression duringf the optimisation
#' @return a list of three elements.
#'  * `type`: a character string of the regression type (linear or quadratic)
#'  * `score`: numeric value of the `OptiCal` score
#'  * `data`: a `data.frame` of the optimal set of calibration observations
#' @export

optimise <- function(calibration_data,
                     p = 0.6,
                     quad = TRUE)
{
  max_p <- nrow(calibration_data)
  min_p <- round(p * max_p, digits = 0)

  opt_seq <- min_p:max_p


  p_comb <- list()
  for (k in seq_along(opt_seq)) {
    p_comb[[k]] <-
      combn(calibration_data$concentration, opt_seq[k], simplify = FALSE)
  }

  p_comb_list <-
    unlist(p_comb, recursive = FALSE)


  p_area <- list()
  for (i in seq_along(p_comb_list)) {
    p_area[[i]] <-
      calibration_data %>% dplyr::filter(concentration %in% p_comb_list[[i]])
  }



  linear <- linear_opt(p_area)

  if (quad == TRUE) {
    quadratic <- quad_opt(p_area)


    if (quadratic$score > linear$score) {
      return(quadratic)
    } else{
      return(linear)
    }
  } else{
    return(linear)
  }

}
