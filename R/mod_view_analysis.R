#' view_analysis UI Function
#'
#' @description A shiny Module for viewing analysis images using slickR.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @importFrom shiny NS tagList
#' @importFrom slickR slickROutput
library(svglite)

mod_view_analysis_ui <- function(id) {
  ns <- NS(id)

  # Make the slickR output dynamic by setting width and height as 100% or auto
  slickROutput(ns("slickr_panel"), width =  800, height = 400)
}



#' view_analysis Server Functions
#'
#' @noRd
#' @importFrom slickR slickR settings
mod_view_analysis_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Use reactiveVal to cache the plots
    cached_plots <- reactiveVal(NULL)

    # Render slickR in the UI only if plots are not already cached
    output$slickr_panel <- renderSlickR({
      if (is.null(cached_plots())) {
        # If not cached, generate the plots and cache them
        plotsToSVG <- replicate(4, xmlSVG({
          par(mar = c(4, 4, 1, 1))  # Set plot margins to avoid crowding
          plot(rnorm(100))           # Random plot
        }, standalone = TRUE), simplify = FALSE)

        # Cache the plots
        cached_plots(plotsToSVG)
      }

      # Use the cached plots in slickR
      slickR(cached_plots(), width =  800, height = 400) + settings(dots = TRUE)
    })
  })
}


## To be copied in the UI
# mod_view_analysis_ui("view_analysis_1")

## To be copied in the server
# mod_view_analysis_server("view_analysis_1")
