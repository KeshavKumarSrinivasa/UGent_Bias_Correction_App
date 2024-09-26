#' select_primary_outcome UI Function
#'
#' @description A shiny Module for selecting the primary outcome from a list.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @importFrom shiny NS tagList
mod_select_primary_outcome_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      inputId = ns("primary_outcome"),  # Namespaced ID
      label = "Select Primary Outcome",  # Label for the dropdown
      choices = c("Outcome 1", "Outcome 2", "Outcome 3"),  # The list of outcomes
      selected = "Outcome 1"  # Pre-select the first value
    )
  )
}

#' select_primary_outcome Server Function
#'
#' @noRd
mod_select_primary_outcome_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Reactive to return the selected outcome
    selected_outcome <- reactive({
      input$primary_outcome
    })

    # You can return or use `selected_outcome()` to capture the user's selection
    return(selected_outcome)
  })
}


## To be copied in the UI
# mod_select_primary_outcome_ui("select_primary_outcome_1")

## To be copied in the server
# mod_select_primary_outcome_server("select_primary_outcome_1")
