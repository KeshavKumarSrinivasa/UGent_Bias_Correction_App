#' volcano_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_volcano_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("plot3"))
  )
}

#' volcano_plot Server Functions
#'
#' @noRd
mod_volcano_plot_server <- function(id,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    plot3 <- renderPlot({
      ggplot2::ggplot(data.frame(x = rnorm(100, mean = 5)), ggplot2::aes(x)) +
        ggplot2::geom_histogram(binwidth = 0.2, fill = "darkred", color = "white") +
        ggplot2::ggtitle("Plot 2: Histogram of Random Data with Mean 5") +
        ggplot2::theme_minimal()
    })
  })
}

## To be copied in the UI
# mod_volcano_plot_ui("volcano_plot_1")

## To be copied in the server
# mod_volcano_plot_server("volcano_plot_1")
