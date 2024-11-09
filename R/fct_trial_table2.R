#' trial_table2
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
trial_table2 <- function() {
  a <- as.data.frame(as.matrix(rbinom(10,1,0.5)))
  return(a)
}
