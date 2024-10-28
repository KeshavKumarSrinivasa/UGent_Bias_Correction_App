#' load_page_05
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
load_page_05 <- function() {
  htmlTemplate(app_sys("app/www/page5_analysis.html"),
                       display_analysis_results = mod_view_analysis_ui("view_analysis_1")
  )
}
