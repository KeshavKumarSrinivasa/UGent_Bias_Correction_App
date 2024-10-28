#' get_page_number
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_page_number <- function(currentPage) {
  print(currentPage)
  as.integer(sub("page", "", currentPage))
}
