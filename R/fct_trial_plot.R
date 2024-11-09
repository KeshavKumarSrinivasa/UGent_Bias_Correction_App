#' trial_plot
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
trial_plot <- function() {
  a <- ggplot2::ggplot(data.frame(x = rnorm(100, mean = 5)), ggplot2::aes(x)) +
    ggplot2::geom_histogram(binwidth = 0.2, fill = "darkred", color = "white") +
    ggplot2::ggtitle("Plot 2: Histogram of Random Data with Mean 5") +
    ggplot2::theme_minimal()

  return(a)
}
