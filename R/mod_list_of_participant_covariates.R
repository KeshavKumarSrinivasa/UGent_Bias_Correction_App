#' list_of_participant_covariates UI Function
#'
#' @description A shiny Module to select the outcome of interest from participant data columns.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param participant_data_columns Character vector of column names from uploaded data.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList selectInput
mod_list_of_participant_covariates_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Dropdown for "What is the outcome of interest?" populated dynamically
    selectInput(
      inputId = ns("outcome_interest"),
      label = "",
      choices = NULL,  # Columns will be updated dynamically.
      selected = NULL
    )
  )
}

#' list_of_participant_covariates Server Function
#'
#' @noRd
mod_list_of_participant_covariates_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Make participant_data_columns reactive if it's a reactive source
    # participant_data_columns <- reactive({
    #   req(r$input$participant_data$participant_dataset_columns())
    #   r$input$participant_data$participant_dataset_columns()
    # })

    # Update dropdown choices when participant_data_columns is available
    observe({
      req(r$input$participant_data$participant_dataset_columns)
      updateSelectInput(session, "outcome_interest", choices = r$input$participant_data$participant_dataset_columns())
    })



    r$input$selected_outcome_of_interest <- reactive({
      req(input$outcome_interest)
      input$outcome_interest
    })
  })
}
