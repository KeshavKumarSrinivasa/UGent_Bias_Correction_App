#' get_valid_column_names
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_valid_column_names <- function(data) {
  if (is.null(data)) {
    stop("No data provided.")
  }
  raw_list_of_variables <- colnames(data)
  valid_column_names <- process_column_names(raw_list_of_variables)
  names(valid_column_names) <- raw_list_of_variables
  return(valid_column_names)
}
