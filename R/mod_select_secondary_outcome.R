#' select_secondary_outcome UI Function
#'
#' @description A shiny Module for selecting the secondary outcome.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @importFrom shiny NS tagList
mod_select_secondary_outcome_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      inputId = ns("secondary_outcome"),  # Namespaced ID
      label = "Select Secondary Outcome",  # Label for the dropdown
      choices = NULL  # Choices will be updated dynamically
    )
  )
}


#' select_secondary_outcome Server Function
#'
#' @noRd
mod_select_secondary_outcome_server <- function(id, primary_outcome) {
  moduleServer(id, function(input, output, session) {
    # Define the list of all possible outcomes
    all_outcomes <- c("Outcome 1", "Outcome 2", "Outcome 3")

    # Update the secondary outcome choices based on primary outcome selection
    observe({
      selected_primary <- primary_outcome()

      # Exclude the selected primary outcome from the secondary choices
      secondary_choices <- setdiff(all_outcomes, selected_primary)

      # Update the choices for the secondary outcome dropdown
      updateSelectInput(session, "secondary_outcome",
                        choices = secondary_choices,
                        selected = secondary_choices[1])  # Default selection (first available)
    })

    # Reactive to return the selected secondary outcome
    selected_secondary <- reactive({
      input$secondary_outcome
    })

    return(selected_secondary)
  })
}


## To be copied in the UI
# mod_select_secondary_outcome_ui("select_secondary_outcome_1")

## To be copied in the server
# mod_select_secondary_outcome_server("select_secondary_outcome_1")
