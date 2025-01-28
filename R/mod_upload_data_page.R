#' upload_data_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_upload_data_page_ui <- function(id) {
  ns <- NS(id)
  htmlTemplate(
    app_sys("app/www/page2_upload.html"),
    metabolomics_data_upload = mod_metabolomics_upload_ui(ns("metabolomics_upload")),
    participant_data_upload = mod_participant_upload_ui(ns("participant_upload")),
    prevalence_data_upload = mod_prevalence_upload_ui(ns("prevalence_upload_1")),
    select_one_of_rows_or_columns = mod_metabolite_along_ui(ns("metabolite_along_1"))
  )
}

#' upload_data_page Server Functions
#'
#' @noRd
mod_upload_data_page_server <- function(id,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # Call the server function for each submodule and capture their outputs
    r$input$metabolomics_data <- mod_metabolomics_upload_server("metabolomics_upload")
    r$input$participant_data <- mod_participant_upload_server("participant_upload")
    r$input$prevalence_data <- mod_prevalence_upload_server("prevalence_upload_1")
    r$input$metabolites_are_rows <- mod_metabolite_along_server("metabolite_along_1")

  })
}

## To be copied in the UI
# mod_upload_data_page_ui("upload_data_page_1")

## To be copied in the server
# mod_upload_data_page_server("upload_data_page_1")
