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
mod_select_secondary_outcome_server <- function(id, primary_outcome, r) {
  moduleServer(id, function(input, output, session) {

    # Observe the primary outcome and update the secondary outcome choices
    observe({
      req(primary_outcome())  # Ensure primary outcome is selected
      req(r$data_cols())  # Ensure dataset columns are available

      # Get the list of all outcomes (columns from the dataset)
      all_outcomes <- r$data_cols()

      # Exclude the selected primary outcome from the secondary choices
      secondary_choices <- setdiff(all_outcomes, primary_outcome())

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
