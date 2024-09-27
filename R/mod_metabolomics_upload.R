#' metabolomics_upload UI Function
#'
#' @description A shiny Module for uploading metabolomics data.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_metabolomics_upload_ui <- function(id) {
  ns <- NS(id)
  tagList(tags$head(
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = app_sys("app/www/w3style.css")
    )
  ),
  fileInput(
    ns("metabolomics_data"),
    label = ""
  ))
}


#' metabolomics_upload Server Function
#'
#' @noRd
mod_metabolomics_upload_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive({
      input$metabolomics_data
    })
  })
}

## To be copied in the UI
# mod_metabolomics_upload_ui("metabolomics_upload_1")

## To be copied in the server
# mod_metabolomics_upload_server("metabolomics_upload_1")
