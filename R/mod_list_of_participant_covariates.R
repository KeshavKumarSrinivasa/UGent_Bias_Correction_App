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
mod_list_of_participant_covariates_server <- function(id,r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    participant_data_columns <- r$input$participant_data$participant_dataset_columns()

    # Update dropdown choices
    observe({
      req(participant_data_columns)  # Ensure columns are available

      updateSelectInput(session, "outcome_interest", choices = participant_data_columns, selected = participant_data_columns[1])
    })


    # This module will return the selected outcome to use in other parts of the app
    selected_outcome <- reactive({
      input$outcome_interest
    })

    # Make selected_outcome available to be accessed outside this module
    return(selected_outcome)
  })
}
