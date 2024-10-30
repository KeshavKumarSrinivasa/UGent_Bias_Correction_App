#' select_alpha_value UI Function
#'
#' @description A shiny Module for selecting an alpha value.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_alpha_value_ui <- function(id) {
  ns <- NS(id)
  sliderInput(ns("alpha_value"),
              label = "Select Value of Alpha",
              min = 0,
              max = 1,
              value = 0.5,
              step = 0.01)
}

#' select_alpha_value Server Function
#'
#' @noRd
mod_select_alpha_value_server <- function(id,r) {
  moduleServer(id, function(input, output, session) {
    r$input$alpha_value <- reactive({
      input$alpha_value
    })
    print(r$input$alpha_value())
  })
}


## To be copied in the UI
# mod_select_alpha_value_ui("select_alpha_value_1")

## To be copied in the server
# mod_select_alpha_value_server("select_alpha_value_1")
