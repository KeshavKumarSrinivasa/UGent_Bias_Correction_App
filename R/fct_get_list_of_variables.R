#' Get List of Variables (Column Names) from Uploaded Data
#'
#' @description A function to extract the column names from a data frame.
#'
#' @param data A data frame from which to extract column names.
#'
#' @return A vector containing the column names.
#' @export
get_list_of_variables <- function(data) {
  if (is.null(data)) {
    stop("No data provided.")
  }

  return(colnames(data))
}
