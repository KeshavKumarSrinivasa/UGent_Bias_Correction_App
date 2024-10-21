#' select_number_of_cv_iterations UI Function
#'
#' @description A shiny Module for selecting the number of cross-validation iterations.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_select_number_of_cv_iterations_ui <- function(id) {

  ns <- NS(id)
  sliderInput(ns("number_of_cv_iterations"),
              "Select Number of CV Iterations",
              min = 5,
              max = 50,
              value = 5)
}


#' select_number_of_cv_iterations Server Function
#'
#' @noRd
mod_select_number_of_cv_iterations_server <- function(id) {
  moduleServer(id, function(input, output, session){
    # Return a reactive expression with the value of the input
    return(reactive({ input$number_of_cv_iterations }))
  })
}

## To be copied in the UI
# mod_select_number_of_cv_iterations_ui("select_number_of_cv_iterations_1")

## To be copied in the server
# mod_select_number_of_cv_iterations_server("select_number_of_cv_iterations_1")
