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

    # Reactive value to cache analysis results
    analysis_result <- reactiveVal(NULL)

    # Run the analysis if not already cached
    observe({
      if (is.null(analysis_result())) {
        analysis_result(perform_analysis(r))  # Run and store the result
      }
    })

    # Reactive value to cache generated PNG plots
    cached_plots <- reactiveVal(NULL)

    observe({
      # Generate PNGs only if not cached
      if (is.null(cached_plots())) {
        req(analysis_result())
        # Get ggplots as png_files from the analysis result
          png_files <- save_plots_as_png(analysis_result())
          cached_plots(png_files)  # Cache the list of PNG file paths
        }
    })

    # Render slickR with the generated PNG images
    output$slickr_panel <- renderSlickR({
      slickR(cached_plots(), width = 800, height = 400) + settings(dots = TRUE)
    })

    # Return the analysis_result reactive
    # return(analysis_result())
    r$output$analysis_results <- reactive({
      req(analysis_result())
      analysis_result()
    })

  })
}

## To be copied in the UI
# mod_analysis_results_page_ui("analysis_results_page_1")

## To be copied in the server
# mod_analysis_results_page_server("analysis_results_page_1")
