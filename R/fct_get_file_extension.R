#' Get File Extension
#'
#' @description A function to extract the file extension from a file name.
#'
#' @param file_name The name of the uploaded file.
#'
#' @return A string representing the file extension (e.g., "csv", "txt").
#' @export
get_file_extension <- function(file_name) {
  tools::file_ext(file_name)
}
