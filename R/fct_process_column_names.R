#' process_column_names
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
process_column_names <- function(column_names) {
  new_column_names <- gsub(" $","",column_names)
  new_column_names <- make.names(new_column_names)
  return(new_column_names)
}
