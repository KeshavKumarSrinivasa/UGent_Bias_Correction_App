#' get_metabolite_columns
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_metabolite_columns <- function(metabolite_data) {
  metabolite_data %>% pull(1)
}
