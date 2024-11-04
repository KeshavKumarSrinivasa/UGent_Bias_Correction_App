#' list_of_participant_covariates UI Function
#'
#' @description A shiny Module to select the outcome of interest from participant data columns.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param participant_data_columns Character vector of column names from uploaded data.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList selectInput
mod_list_of_participant_covariates_ui <- function(id) {
  ns <- NS(id)
  tagList(# Dropdown for "What is the outcome of interest?" populated dynamically
    selectInput(
      inputId = ns("outcome_interest"),
      label = "",
      choices = NULL,
      # Columns will be updated dynamically.
      selected = NULL
    ))
}

#' list_of_participant_covariates Server Function
#'
#' @noRd
mod_list_of_participant_covariates_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    ooi_choices <- reactive({

      t4 <- r$input$participant_data$actual_participant_dataset_columns()
      t7 <- r$input$selected_outcome_of_interest()
      t5 <- isolate(r$input$selected_actual_outcome_of_interest())
      t6 <- setdiff(t4, t5)
      t8 <- setdiff(t6, t7)
      t99 <- setdiff(t4, t7)
      if (eval(parse(text = r$input$study_for_another_outcome()))) {
        t88 <- c(t7, t8)
        return(t88)
      } else{
        r$input$selected_actual_outcome_of_interest(t8[1])
        t999 <- c(t7, t99)
        return(t999)
      }
    })

    # Update dropdown choices when participant_data_columns is available
    observe({
      req(ooi_choices())
      updateSelectInput(session, "outcome_interest", choices = ooi_choices())
    })

    observe(
        {
          req(input$outcome_interest)
          r$input$selected_outcome_of_interest(input$outcome_interest)
        }
      )
  })
}
