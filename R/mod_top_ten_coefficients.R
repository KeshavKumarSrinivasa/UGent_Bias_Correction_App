#' top_ten_coefficients UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_top_ten_coefficients_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("plot4"))
  )
}

#' top_ten_coefficients Server Functions
#'
#' @noRd
# Module Server Function
mod_top_ten_coefficients_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    message("hello")
    output$plot4 <- renderPlot({
      # Simple base R plot for testing
      hist(
        rnorm(100, mean = 5),
        breaks = 20,
        col = "darkred",
        main = "Histogram of Random Data with Mean 5",
        xlab = "Values",
        border = "white"
      )

    })



  })
}

## To be copied in the UI
# mod_top_ten_coefficients_ui("top_ten_coefficients_1")

## To be copied in the server
# mod_top_ten_coefficients_server("top_ten_coefficients_1")
