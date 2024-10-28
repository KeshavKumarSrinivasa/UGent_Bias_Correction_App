#' load_page_06
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
load_page_06 <- function() {
  htmlTemplate(app_sys("app/www/page6_downloads.html"),
               download_ipw_button = mod_download_ipw_ui("download_ipw_1"),
               # Add the IPW download button here
               download_model_coefficients = mod_download_model_coefficients_ui("download_model_coefficients_1"),
               download_univariate_analysis = mod_download_univariate_analysis_ui("download_univariate_analysis_1"),
               download_smd_analysis = mod_download_smd_analysis_ui("download_smd_analysis_1"))
}
