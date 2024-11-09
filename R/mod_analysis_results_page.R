#' analysis_results_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_analysis_results_page_ui <- function(id) {
  ns <- NS(id)
  htmlTemplate(app_sys("app/www/page5_analysis.html"),

               display_analysis_results = mod_view_analysis_ui(ns("view_analysis_1")))
}

#' analysis_results_page Server Functions
#'
#' @noRd
mod_analysis_results_page_server <- function(id,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
#
    observe({
      alpha <- r$input$alpha_value()
      cv_iter <- r$input$cv_iter()
      selected_outcome_of_interest <- r$input$selected_outcome_of_interest()
      selected_actual_outcome_of_interest <- r$input$selected_actual_outcome_of_interest()
      study_for_another_outcome <- r$input$study_for_another_outcome()
      covariates_to_adjust <- r$input$covariates_to_adjust()

      r$input$entered_values(
        list(
          alpha,
          cv_iter,
          selected_outcome_of_interest,
          selected_actual_outcome_of_interest,
          study_for_another_outcome,
          covariates_to_adjust
        )
      )
    })

    observe({
      req(r$input$alpha_value())
      req(r$input$cv_iter())
      req(r$input$selected_outcome_of_interest())
      req(r$input$selected_actual_outcome_of_interest())
      req(r$input$study_for_another_outcome())
      req(r$input$covariates_to_adjust())
      req(r$input$entered_values())

      entered_values <- r$input$entered_values()

      mod_view_analysis_server("view_analysis_1",r)
    })



  })
}

## To be copied in the UI
# mod_analysis_results_page_ui("analysis_results_page_1")

## To be copied in the server
# mod_analysis_results_page_server("analysis_results_page_1")
