#' participant_upload UI Function
#'
#' @description A shiny Module for uploading participant data.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_participant_upload_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(ns("participant_data"), label = "")
  )
}


#' participant_upload Server Function
#'
#' @noRd
mod_participant_upload_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive({
      input$participant_data
    })
  })
}


## To be copied in the UI
# mod_participant_upload_ui("participant_upload_1")

## To be copied in the server
# mod_participant_upload_server("participant_upload_1")
