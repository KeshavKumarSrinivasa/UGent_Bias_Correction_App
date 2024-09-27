#' navigation
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd

navigate_back <- function(page, output, server_modules = list()) {
  output$pageContent <- render_page(page)

  # Call the relevant server modules
  for (mod in server_modules) {
    mod$server(mod$id)
  }
}
