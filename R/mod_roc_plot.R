#' roc_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_roc_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("plot2"))
  )
}

#' roc_plot Server Functions
#'
#' @noRd
mod_roc_plot_server <- function(id,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    plot2 <- renderPlot({
      ggplot2::ggplot(data.frame(x = rnorm(100)), ggplot2::aes(x)) +
        ggplot2::geom_histogram(binwidth = 0.2, fill = "steelblue", color = "white") +
        ggplot2::ggtitle("Plot 1: Histogram of Random Data") +
        ggplot2::theme_minimal()
    })

  })
}

## To be copied in the UI
# mod_roc_plot_ui("roc_plot_1")

## To be copied in the server
# mod_roc_plot_server("roc_plot_1")
