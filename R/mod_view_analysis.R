library(slickR)
library(svglite)
library(gdtools)
library(shiny)


mod_view_analysis_ui <- function(id) {
  ns <- NS(id)

  # Output the slickR carousel with PNG images
  # plotOutput(ns("slickr_panel"))
  # selectInput(ns("slickr_panel"),"WHATEVER",choices=LETTERS,selected=LETTERS[1])
  slickROutput(ns("slick_output"),width='100%',height='200px')

}

mod_view_analysis_server <- function(id,r=r){
  moduleServer(id, function(input, output, session) {
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
    cached_plots <- reactiveVal()
    carousel_plots <- reactiveVal()

    # print(":::::::::::::::::::::::::")
    # observe({
    #   req(analysis_result())
    #   print("ROC PLOT")
    #   print(analysis_result()$multivariate_results$roc_plot)
    #   print("CONFUSION MATRIX")
    #   print(analysis_result()$multivariate_results$confusion_matrix)
    # }
    # )
    #
    # print(":::::::::::::::::::::::::")

    plots_analysis <- reactiveVal()
    observe({
      # Generate PNGs only if not cached
      if (is.null(cached_plots())) {
        req(analysis_result())

        # Get ggplots as png_files from the analysis result
        result_plots <- save_plots_as_png(analysis_result())
        png_files <- result_plots$files

        r$output$all_plots(result_plots)

        cached_plots(png_files)  # Cache the list of PNG file paths
        # print(cached_plots())
        # print(":::::::::")
        # print(r$output$all_plots()$files)
      }
    })

    # Render slickR with the generated PNG images


     observe({
      req(r$output$all_plots())
      print("$$$$$$$$$$$$$")
      print(show(r$output$all_plots()$plot_objects$ROC_PLOT))

      carousel_plots(lapply(r$output$all_plots()$plot_objects, function(x) {
        # svglite::xmlSVG(x)
        x
      }))
    })

      output$slick_output <- renderSlickR({

        req(carousel_plots())

        # slickR(replicate(4,{
        #
        #   xmlSVG({hist(rnorm(100),
        #                col = 'darkgray',
        #                border = 'white')},
        #          standalone=TRUE)
        #
        # },simplify = FALSE), width = 800, height = 400) + settings(dots = TRUE)})

        # r$output$all_plots()$ROC_PLOT
        slickR(carousel_plots(),
               slideId = 'slick1',
               height = 400,
               width = 800)
      })



      # Return the analysis_result reactive
      r$output$analysis_results <- reactive({
        req(analysis_result())
        analysis_result()
      })
      return(r$output$analysis_results())


})
}
