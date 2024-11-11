#' downloads_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_downloads_page_ui <- function(id) {
  ns <- NS(id)
  htmlTemplate(app_sys("app/www/page6_downloads.html"),
               download_ipw_button = mod_download_ipw_ui(ns("download_ipw_1")),
               # Add the IPW download button here
               download_model_coefficients = mod_download_model_coefficients_ui(ns("download_model_coefficients_1")),
               download_univariate_analysis = mod_download_univariate_analysis_ui(ns("download_univariate_analysis_1")),
               download_smd_analysis = mod_download_smd_analysis_ui(ns("download_smd_analysis_1")),
               download_entered_input = mod_download_entered_data_ui(ns("download_entered_data_1")),
               download_complete_report = mod_download_complete_report_ui(ns("download_complete_report_1")))
}

#' downloads_page Server Functions
#'
#' @noRd
mod_downloads_page_server <- function(id,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    # print("::::::::::::")
    # print(names(r$output))
    # print("::::::::::::")
    mod_download_ipw_server("download_ipw_1",r)
    mod_download_model_coefficients_server("download_model_coefficients_1",r)
    mod_download_univariate_analysis_server("download_univariate_analysis_1",r)
    mod_download_smd_analysis_server("download_smd_analysis_1",r)
    mod_download_entered_data_server("download_entered_data_1",r)
    mod_download_complete_report_server("download_complete_report_1",r)
  })
}

## To be copied in the UI
# mod_downloads_page_ui("downloads_page_1")

## To be copied in the server
# mod_downloads_page_server("downloads_page_1")
