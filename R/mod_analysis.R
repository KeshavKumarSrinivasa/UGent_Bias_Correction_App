#' analysis UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList

# Analysis UI function
mod_analysis_ui <- function(id) {
  ns <- NS(id)
  tagList(
    htmlTemplate(
      app_sys("app/www/page5_analysis.html"),
      display_analysis_results = mod_view_analysis_ui(ns("view_analysis"))
    )
  )
}

# Analysis Server function
mod_analysis_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Call the analysis view module
    mod_view_analysis_server("view_analysis")
  })
}


## To be copied in the UI
# mod_analysis_ui("analysis_1")

## To be copied in the server
# mod_analysis_server("analysis_1")
