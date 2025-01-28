#' prevalence_upload UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_prevalence_upload_ui <- function(id) {
  ns <- NS(id)
  tagList(fileInput(ns("prevalence_data"), label = ""))
}

#' prevalence_upload Server Functions
#'
#' @noRd
mod_prevalence_upload_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Step 1: Get the file extension using fct_get_file_extension
    file_ext <- reactive({
      req(input$prevalence_data)  # Ensure the file input exists
      get_file_extension(input$prevalence_data$datapath)
    })

    # Step 2: Read the file using the read_file function
    actual_dataset <- reactive({
      req(input$prevalence_data)  # Ensure the file input exists
      file_path <- input$prevalence_data$datapath
      file_extension <- file_ext()  # Get the file extension
      read_file_as_list(file_path, file_extension)  # Read the file
    })

    print(actual_dataset)

    return(list(population_distribution_covariates = actual_dataset))

  })
}

## To be copied in the UI
# mod_prevalence_upload_ui("prevalence_upload_1")

## To be copied in the server
# mod_prevalence_upload_server("prevalence_upload_1")
