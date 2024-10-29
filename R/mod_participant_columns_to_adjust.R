#' participant_columns_to_adjust UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_participant_columns_to_adjust_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Checkbox group input for selecting columns to adjust for
    checkboxGroupInput(
      inputId = ns("columns_to_adjust"),
      label = "Select the columns to adjust for:",
      choices = NULL  # Choices will be populated dynamically
    )
  )
}
#' participant_columns_to_adjust Server Functions
#'
#' @noRd
mod_participant_columns_to_adjust_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Extract values
    participant_data_columns <- r$input$participant_data$participant_dataset_columns()
    selected_outcome <- r$input$selected_outcome_of_interest()
    study_for_another_outcome <- r$input$study_for_another_outcome()

    # Observe for changes in required inputs and update checkbox choices
    observe({
      req(participant_data_columns, selected_outcome, study_for_another_outcome)

      # Determine choices based on study design choice
      if (study_for_another_outcome) {
        # Combine both lists if the study was designed for another outcome
        participant_data_remaining_covariates <- r$input$selected_remaining_outcome_of_interest()

        remaining_choices <- setdiff(
          unique(c(participant_data_columns, participant_data_remaining_covariates)),
          selected_outcome
        )
      } else {
        # Use only participant_data_columns otherwise
        remaining_choices <- setdiff(participant_data_columns, selected_outcome)
      }

      # Update the checkbox group with the calculated remaining choices
      updateCheckboxGroupInput(session, "columns_to_adjust", choices = remaining_choices)
    })

    # Capture selected columns as a reactive output
    selected_columns_to_adjust <- reactive({
      input$columns_to_adjust
    })

    # Make selected_columns_to_adjust accessible outside the module
    return(selected_columns_to_adjust)
  })
}
## To be copied in the UI
# mod_participant_columns_to_adjust_ui("participant_columns_to_adjust_1")

## To be copied in the server
# mod_participant_columns_to_adjust_server("participant_columns_to_adjust_1")
