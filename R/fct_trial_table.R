#' trial_table
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
trial_table <- function() {
  a <- as.data.frame(as.matrix(rnorm(10)))
  return(a)
}
