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

    # Reactive expressions to handle each input
    participant_data_columns <- reactive({
      req(r$input$participant_data$participant_dataset_columns)
      r$input$participant_data$participant_dataset_columns()
    })

    selected_outcome <- reactive({
      req(r$input$selected_outcome_of_interest)
      r$input$selected_outcome_of_interest()
    })

    study_is_for_another_outcome <- reactive({
      req(r$input$study_for_another_outcome)
      r$input$study_for_another_outcome()
    })

    selected_actual_study_outcome <- reactive({
      req(r$input$selected_remaining_outcome_of_interest)
      r$input$selected_remaining_outcome_of_interest()
    })

    remaining_covariates_for_primary_outcome <- reactive({
      req(r$input$remaining_choices_for_primary_outcome)
      r$input$remaining_choices_for_primary_outcome
    })

    # Observe for changes in required inputs and update checkbox choices
    observeEvent(remaining_covariates_for_primary_outcome(),{
      req(participant_data_columns(), selected_outcome(),study_is_for_another_outcome(),selected_actual_study_outcome())

      # Determine choices based on study design choice
      is_study_for_another_outcome <- eval(parse(text = study_is_for_another_outcome()))

      if (is_study_for_another_outcome) {

        remaining_choices <- setdiff(
          c(participant_data_columns()),
          c(selected_actual_study_outcome(),selected_outcome())
        )
      } else {
        # Use only participant_data_columns otherwise
        remaining_choices <- setdiff(participant_data_columns(), selected_outcome())
      }

      # Update the checkbox group with the calculated remaining choices
      updateCheckboxGroupInput(session, "columns_to_adjust", choices = remaining_choices)
    })

    # Store selected columns in r$input for access outside the module
    r$input$covariates_to_adjust <- reactive({
      req(input$columns_to_adjust)
      input$columns_to_adjust
    })
  })
}
## To be copied in the UI
# mod_participant_columns_to_adjust_ui("participant_columns_to_adjust_1")

## To be copied in the server
# mod_participant_columns_to_adjust_server("participant_columns_to_adjust_1")
