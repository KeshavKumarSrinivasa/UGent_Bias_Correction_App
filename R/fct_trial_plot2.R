#' trial_plot2
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
trial_plot2 <- function() {
  a <- ggplot2::ggplot(data.frame(x = rnorm(100)), ggplot2::aes(x)) +
    ggplot2::geom_histogram(binwidth = 0.2, fill = "steelblue", color = "white") +
    ggplot2::ggtitle("Plot 1: Histogram of Random Data") +
    ggplot2::theme_minimal()

  return(a)
}
