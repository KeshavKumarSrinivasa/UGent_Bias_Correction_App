#' select_parameters_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_parameters_page_ui <- function(id) {
  ns <- NS(id)
  htmlTemplate(
    app_sys("app/www/page4_parameters.html")
    # cv_iter_slider = mod_select_number_of_cv_iterations_ui(ns("select_number_of_cv_iterations_1")),
    # alpha_value_slider = mod_select_alpha_value_ui(ns("select_alpha_value_1"))
  )
}

#' select_parameters_page Server Functions
#'
#' @noRd
mod_select_parameters_page_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    r$input$alpha_value <- reactiveVal()
    r$input$cv_iter <- reactiveVal()
    r$output$all_plots <- reactiveVal()
    mod_select_number_of_cv_iterations_server("select_number_of_cv_iterations_1",r)
    mod_select_alpha_value_server("select_alpha_value_1",r)
  })
}

## To be copied in the UI
# mod_select_parameters_page_ui("select_parameters_page_1")

## To be copied in the server
# mod_select_parameters_page_server("select_parameters_page_1")
