#' get_matrix_from_data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_matrix_from_data <- function(metabolite_data) {
  metabolite_data <- metabolite_data %>% select(-1)
  return(as.matrix(metabolite_data))
}
