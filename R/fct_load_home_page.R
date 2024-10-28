#' load_home_page
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
load_home_page <- function() {
  htmlTemplate(app_sys("app/www/page0_landing.html"))
}
