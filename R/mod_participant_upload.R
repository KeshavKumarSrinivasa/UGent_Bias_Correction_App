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

    # Step 1: Get the file extension using fct_get_file_extension
    file_ext <- reactive({
      req(input$participant_data)  # Ensure the file input exists
      get_file_extension(input$participant_data$datapath)
    })

    # Step 2: Read the file using the read_file function
    dataset <- reactive({
      req(input$participant_data)  # Ensure the file input exists
      file_path <- input$participant_data$datapath
      file_extension <- file_ext()  # Get the file extension
      read_file(file_path, file_extension)  # Read the file
    })

    # Step 3: Get the list of variables/columns using fct_get_list_of_variables
    dataset_columns <- reactive({
      req(dataset())  # Ensure dataset is available
      get_list_of_variables(dataset())
    })

    # Return reactive expressions (not invoked immediately)
    return(list(
      participant_dataset_columns = dataset_columns,
      participant_dataset = dataset
    ))
  })
}

## To be copied in the UI
# mod_participant_upload_ui("participant_upload_1")

## To be copied in the server
# mod_participant_upload_server("participant_upload_1")
