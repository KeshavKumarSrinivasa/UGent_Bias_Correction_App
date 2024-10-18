#' select_outcome_of_interest UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_outcome_of_interest_ui <- function(id) {
  ns <- NS(id)
  tagList(selectInput(
    ns,
    label = "",
    choices = NULL,
    selected = NULL
  )

  )
}

#' select_outcome_of_interest Server Functions
#'
#' @noRd
mod_select_outcome_of_interest_server <- function(id,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    observe({
      req(r$participant_data$participant_dataset_columns())

      columns <- r$participant_data$participant_dataset_columns()

      # Ensure columns are valid and update the selectInput
      if (!is.null(columns) && length(columns) > 0) {
        updateSelectInput(session, ns("outcome_of_interest"),
                          choices = columns,  # Populate the choices with column names
                          selected = columns[1])  # Pre-select the first column
      }
    })

    # Return the selected outcome
    reactive({
      input$outcome_of_interest
    })


  })
}

## To be copied in the UI
# mod_select_outcome_of_interest_ui("select_outcome_of_interest_1")

## To be copied in the server
# mod_select_outcome_of_interest_server("select_outcome_of_interest_1")
