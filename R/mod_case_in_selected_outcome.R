#' case_in_selected_outcome UI Function
#'
#' @description A shiny Module for displaying a case selector if the outcome is binary.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_case_in_selected_outcome_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("case_in_outcome_of_interest"))
  )
}

#' case_in_selected_outcome Server Function
#'
#' @noRd
mod_case_in_selected_outcome_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    outcome_number_of_factors <- reactive({
      variable <- r$input$selected_outcome_of_interest()
      data <- r$input$participant_data$participant_dataset()

      # Calculate the number of unique factor levels
      number_of_factors <- nlevels(as.factor(data[[variable]]))
      return(number_of_factors)
    })

    output$case_in_outcome_of_interest <- renderUI({
      if (outcome_number_of_factors() == 2) {
        # Display a selectInput with the levels of the selected variable
        selectInput(
          ns("case_in_outcome_of_interest"),
          label = "Select Case:",
          choices = levels(as.factor(r$input$participant_data$participant_dataset()[[r$input$selected_outcome_of_interest()]]))
        )
      } else {
        # Display a message if the outcome is not binary
        div("Please select a binary outcome.")
      }
    })
  })
}

## To be copied in the UI
# mod_case_in_selected_outcome_ui("case_in_selected_outcome_1")

## To be copied in the server
# mod_case_in_selected_outcome_server("case_in_selected_outcome_1")
