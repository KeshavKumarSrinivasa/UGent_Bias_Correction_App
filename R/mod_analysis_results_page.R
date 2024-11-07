#' analysis_results_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_analysis_results_page_ui <- function(id) {
  ns <- NS(id)
  htmlTemplate(app_sys("app/www/page5_analysis.html"),

               display_analysis_results = mod_view_analysis_ui(ns("view_analysis_1")))
}

#' analysis_results_page Server Functions
#'
#' @noRd
mod_analysis_results_page_server <- function(id,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    mod_view_analysis_server("view_analysis_1",r)


  })
}

## To be copied in the UI
# mod_analysis_results_page_ui("analysis_results_page_1")

## To be copied in the server
# mod_analysis_results_page_server("analysis_results_page_1")
