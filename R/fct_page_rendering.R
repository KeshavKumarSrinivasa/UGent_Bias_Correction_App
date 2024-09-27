#' page_rendering
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' @import shiny
render_page <- function(page, ...) {
  renderUI({
    htmlTemplate(
      app_sys(paste0("app/www/", page, ".html")),
      ...
    )
  })
}
