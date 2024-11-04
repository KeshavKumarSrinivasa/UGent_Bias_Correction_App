#' get_valid_dataset
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_valid_dataset <- function(data) {
  if (is.null(data)) {
    stop("No data provided.")
  }
  column_names <- colnames(data)
  valid_column_names <- process_column_names(column_names)
  colnames(data) <- valid_column_names
  return(data)
}
