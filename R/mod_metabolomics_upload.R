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

    # Step 1: Get the file extension using fct_get_file_extension
    file_ext <- reactive({
      req(input$metabolomics_data)  # Ensure the file input exists
      get_file_extension(input$metabolomics_data$datapath)
    })

    # Step 2: Read the file using the read_file function
    dataset <- reactive({
      req(input$metabolomics_data)  # Ensure the file input exists
      file_path <- input$metabolomics_data$datapath
      file_extension <- file_ext()  # Get the file extension
      read_file(file_path, file_extension)  # Read the file
    })


  })
}


## To be copied in the UI
# mod_metabolomics_upload_ui("metabolomics_upload_1")

## To be copied in the server
# mod_metabolomics_upload_server("metabolomics_upload_1")
