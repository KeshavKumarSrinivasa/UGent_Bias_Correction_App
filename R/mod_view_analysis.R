mod_view_analysis_ui <- function(id) {
  ns <- NS(id)

  # Output the slickR carousel with PNG images
  slickROutput(ns("slickr_panel"), width = 800, height = 400)
}

mod_view_analysis_server <- function(id,r=r)
                                     # participant_data,
                                     # metabolomics_data,
                                     # metabolites_are_rows,
                                     # selected_primary_outcome,
                                     # selected_secondary_outcome,
                                     # cv_iter,
                                     # alpha)
  {
  moduleServer(id, function(input, output, session) {
    participant_data = r$participant_data$participant_dataset()
    metabolomics_data = r$metabolomics_data$metabolomics_dataset()
    metabolites_are_rows = r$metabolites_are_rows()
    selected_primary_outcome = r$primary_outcome
    selected_secondary_outcome = r$input$selected_outcome_of_interest
    confounding_bias_variables = r$input$covariates_to_adjust
    cv_iter = r$cv_iter
    alpha_val = r$alpha

    ns <- session$ns

    # Reactive value to cache analysis results
    analysis_result <- reactiveVal(NULL)

    # Code to Run Analysis
    run_analysis <- function() {
      # Replace with your actual analysis logic
      analysis <- run_pipeline(participant_data = participant_data,
                               metabolite_data = metabolomics_data,
                               primary_outcome = selected_primary_outcome,
                               secondary_outcome =  selected_secondary_outcome,
                               confounding_bias_variables = confounding_bias_variables,
                               alpha_val = alpha_val,
                               cv_iter = cv_iter,
                               metabolite_ids_are_rows = metabolites_are_rows)  # Assuming run_pipeline() returns a list of ggplot objects
      return(analysis)  # Ensure you're returning the correct variable
    }

    # Run the analysis if not already cached
    observe({
      if (is.null(analysis_result())) {
        analysis_result(run_analysis())  # Run and store the result
      }
    })

    tmp_dir <- tempdir()

    # Reactive value to cache generated PNG plots
    cached_plots <- reactiveVal(NULL)

    observe({
      # Generate PNGs only if not cached
      if (is.null(cached_plots())) {
        req(analysis_result())
        # Get ggplots from the analysis result
        analysis_plots <- list(roc_plot = analysis_result()$multivariate_results$roc_plot,
                               volcano_plot=analysis_result()$univariate_results$volcano_plot)

        if (!is.null(analysis_plots)) {
          png_files <- vector("list", length = length(analysis_plots))  # List to store file paths

          # Loop through the ggplot objects and save them as PNGs
          for (i in seq_along(analysis_plots)) {
            png_file <- file.path(tmp_dir, paste0("plot_", i, ".png"))
            ggsave(filename = png_file, plot = analysis_plots[[i]], width = 8, height = 4, dpi = 300)
            png_files[[i]] <- png_file  # Store file path in the list
          }

          cached_plots(png_files)  # Cache the list of PNG file paths
        }
      }
    })

    # Render slickR with the generated PNG images
    output$slickr_panel <- renderSlickR({
      slickR(cached_plots(), width = 800, height = 400) + settings(dots = TRUE)
    })

    # Return the analysis_result reactive
    return(analysis_result)



  })
}
