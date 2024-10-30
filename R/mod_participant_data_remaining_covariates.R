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
      req(r$input$participant_data$participant_dataset_columns())
      req(r$input$selected_outcome_of_interest())
      # req(r$input$study_for_another_outcome())
      req(r$input$selected_actual_outcome_of_interest())
      t1 <- r$input$participant_data$participant_dataset_columns()
      t2 <- isolate(r$input$selected_outcome_of_interest())
      t3 <- setdiff(t1,t2)
      t4 <- isolate(r$input$selected_actual_outcome_of_interest())
      t5 <- setdiff(t3,t4)
      t6 <- c(t4,t5)
      updateSelectInput(session, "remaining_covariates", choices = t6)
    })

    selected_actual_outcome_of_interest <- reactive({

      if (is.null(input$remaining_covariates)) {
        return(r$input$participant_data$participant_dataset_columns()[2])
      } else{
        return(input$remaining_covariates)
      }
    })



    # Assign the selected covariate to r$input
    r$input$selected_actual_outcome_of_interest(selected_actual_outcome_of_interest())
  })
}
## To be copied in the UI
# mod_participant_data_remaining_covariates_ui("participant_data_remaining_covariates_1")

## To be copied in the server
# mod_participant_data_remaining_covariates_server("participant_data_remaining_covariates_1")
