#' select_outcomes_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_outcomes_page_ui <- function(id) {
  ns <- NS(id)
  htmlTemplate(app_sys("app/www/page3_outcomes.html"),
               participant_data_covariates = mod_list_of_participant_covariates_ui(ns("list_of_participant_covariates_1")),
               study_for_another_outcome = mod_study_for_another_outcome_ui(ns("study_for_another_outcome_1")),
               participant_data_remaining_covariates = mod_participant_data_remaining_covariates_ui(ns("participant_data_remaining_covariates_1")),
               participant_columns_to_adjust = mod_participant_columns_to_adjust_ui(ns("participant_columns_to_adjust_1")))
}

#' select_outcomes_page Server Functions
#'
#' @noRd
mod_select_outcomes_page_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Store reactive outputs from each submodule in r$input
    r$input$selected_outcome_of_interest <- mod_list_of_participant_covariates_server(ns("list_of_participant_covariates_1"), r)
    r$input$study_for_another_outcome <- mod_study_for_another_outcome_server(ns("study_for_another_outcome_1"))
    r$input$selected_remaining_outcome_of_interest <- mod_participant_data_remaining_covariates_server(ns("participant_data_remaining_covariates_1"), r)
    r$input$covariates_to_adjust <- mod_participant_columns_to_adjust_server(ns("participant_columns_to_adjust_1"), r)
  })
}
## To be copied in the UI
# mod_select_outcomes_page_ui("select_outcomes_page_1")

## To be copied in the server
# mod_select_outcomes_page_server("select_outcomes_page_1")
