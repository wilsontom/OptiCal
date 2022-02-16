# OptiCal

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) [![R-CMD-check](https://github.com/wilsontom/OptiCal/workflows/R-CMD-check/badge.svg)](https://github.com/wilsontom/OptiCal/actions)

> **Opti**mise **Cal**ibrants

### Getting Started

`OptiCal` can be installed directly from GitHub 

```r
remotes::install_github('wilsontom/OptiCal')
```

The input data needs to be a two column `data.frame`, with columns named `concentration` and `area`

To run the optimisation, use the function

```r
optimised_data <- optimise(calibrant_data, p = 0.6, quad = TRUE)
```

The `p` argument (0 - 1) is the minimum proportion of samples that have to be utilised in the calibration models. For example, if the input data is a 10-point calibration curve, and `p` is 0.6, then each calibration model tested during the optimisation must contain at least 6 samples. 

The `optimise` function will always run a linear model, but if `quad = TRUE` then a quadratic fit is also included, and the optimum between the tw returned. 



