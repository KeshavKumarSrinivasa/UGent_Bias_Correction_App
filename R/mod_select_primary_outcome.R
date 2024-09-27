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
      choices = NULL,  # Choices will be dynamically populated from the server
      selected = NULL  # No default selection initially
    )
  )
}

#' select_primary_outcome Server Function
#'
#' @noRd
mod_select_primary_outcome_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {

    # Observe the reactive dataset columns and update the dropdown choices
    observe({
      req(r$data_cols())  # Wait until r$data_cols is populated

      columns <- r$data_cols()  # Get the list of columns

      # Ensure columns are valid and update the selectInput
      if (!is.null(columns) && length(columns) > 0) {
        updateSelectInput(session, "primary_outcome",
                          choices = columns,  # Populate the choices with column names
                          selected = columns[1])  # Pre-select the first column
      }
    })

    # Return the selected primary outcome
    reactive({
      input$primary_outcome  # Return the selected outcome
    })
  })
}
