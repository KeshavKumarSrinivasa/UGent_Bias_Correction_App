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
      label = "",
      choices = NULL,  # Placeholder choices; update dynamically in server
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


    # Observe and update dropdown choices when conditions are met
    observe({

      t1 <- r$input$participant_data$participant_dataset_columns()
      t2 <- r$input$selected_outcome_of_interest()
      t3 <- setdiff(t1,t2)
      t4 <- r$input$selected_actual_outcome_of_interest()
      t5 <- setdiff(t3,t4)
      t6 <- c(t4,t5)
      updateSelectInput(session, "remaining_covariates", choices = t6)
    })


    observe(
      {
        req(input$remaining_covariates)

        r$input$selected_actual_outcome_of_interest(input$remaining_covariates)

      }


    )
  })
}
## To be copied in the UI
# mod_participant_data_remaining_covariates_ui("participant_data_remaining_covariates_1")

## To be copied in the server
# mod_participant_data_remaining_covariates_server("participant_data_remaining_covariates_1")
