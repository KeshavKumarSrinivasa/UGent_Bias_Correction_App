#' participant_data_remaining_covariates UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_participant_data_remaining_covariates_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Dropdown for remaining covariates, only displayed if show_dropdown is TRUE
    selectInput(
      inputId = ns("remaining_covariates"),
      label = "What was the study designed for?",
      choices = NULL,  # Will be populated dynamically
      selected = NULL
    )
  )
}

#' participant_data_remaining_covariates Server Functions
#'
#' @noRd
mod_participant_data_remaining_covariates_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Observe for changes in study outcome and update dropdown choices accordingly

    # Get participant data columns and selected outcome
    participant_data_columns <- r$input$participant_data$participant_dataset_columns()
    selected_outcome <- r$input$selected_outcome_of_interest()

    # Check if dropdown should be shown based on study design choice
    show_dropdown <- r$input$study_for_another_outcome()


    observe({
      req(participant_data_columns, selected_outcome, show_dropdown)

      if (show_dropdown) {
        # Update dropdown choices excluding the selected outcome
        remaining_choices <- setdiff(participant_data_columns, selected_outcome)
        updateSelectInput(session, "remaining_covariates", choices = remaining_choices, selected = remaining_choices[1])
      }
    })

    # Reactive to return the selected covariate
    selected_covariate <- reactive({
      req(r$input$study_for_another_outcome())  # Only return if dropdown is visible
      input$remaining_covariates
    })

    # Make selected_covariate accessible outside the module
    return(selected_covariate)
  })
}
## To be copied in the UI
# mod_participant_data_remaining_covariates_ui("participant_data_remaining_covariates_1")

## To be copied in the server
# mod_participant_data_remaining_covariates_server("participant_data_remaining_covariates_1")
