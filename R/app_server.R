#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  # Cache the UI so that it can be reused when navigating back to page 5
  cached_analysis_ui <- reactiveVal(NULL)

  # Helper function to render analysis page with the analysis module UI
  render_analysis_page <- function() {
    # Check if the UI has already been cached
    if (is.null(cached_analysis_ui())) {
      # Render the UI for the first time and cache it
      output$pageContent <- renderUI({
        htmlTemplate(
          app_sys("app/www/page5_analysis.html"),
          display_analysis_results = mod_view_analysis_ui("view_analysis_1")  # Placeholder for analysis results
        )
      })

      # Call the server logic for the analysis module
      mod_view_analysis_server("view_analysis_1")

      # Cache the analysis UI for later use
      cached_analysis_ui(TRUE)

    } else {
      # Reuse the cached UI and ensure the content is still displayed
      output$pageContent <- renderUI({
        htmlTemplate(
          app_sys("app/www/page5_analysis.html"),
          display_analysis_results = mod_view_analysis_ui("view_analysis_1")  # Placeholder for analysis results
        )
      })
    }
  }

  # Load the initial page (Home Page)
  output$pageContent <- renderUI({
    htmlTemplate(app_sys("app/www/page0_landing.html"))
  })

  # Observe when "Go to Page 1" is clicked
  observeEvent(input$get_started, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page1_welcome.html"))  # Load Page 1
    })
  })

  # Observe when "continue" is clicked
  observeEvent(input$continue, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page2_upload.html"),
                   metabolomics_data_upload = mod_metabolomics_upload_ui("metabolomics_upload"),
                   participant_data_upload = mod_participant_upload_ui("participant_upload"),
                   select_one_of_rows_or_columns = mod_metabolite_along_ui("metabolite_along_1"))  # Load Page 2
    })
  })

  # Handle navigation to Page 3 (outcomes)
  observeEvent(input$next3, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page3_outcomes.html"),
                   select_primary_outcome = mod_select_primary_outcome_ui("select_primary_outcome_1"),
                   select_secondary_outcome = mod_select_secondary_outcome_ui("select_secondary_outcome_1"))  # Load Page 3
    })

    # Call primary outcome server module
    selected_primary_outcome <- mod_select_primary_outcome_server("select_primary_outcome_1")

    # Call secondary outcome server module with primary outcome selection as input
    mod_select_secondary_outcome_server("select_secondary_outcome_1", selected_primary_outcome)
  })

  # Handle navigation to Page 4 (parameters)
  observeEvent(input$next4, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page4_parameters.html"),
                   select_number_of_cv_iterations = mod_select_number_of_cv_iterations_ui("select_number_of_cv_iterations_1"),
                   select_alpha_value = mod_select_alpha_value_ui("select_alpha_value_1"))  # Load Page 4
    })
  })

  # Handle navigation to Page 5 (analysis)
  observeEvent(input$next5, {
    render_analysis_page()  # Call the helper function to render the analysis page
  })

  # Handle navigation to Page 6 (downloads)
  observeEvent(input$next6, {
    output$pageContent <- renderUI({
      htmlTemplate(
        app_sys("app/www/page6_downloads.html"),
        download_ipw_button = mod_download_ipw_ui("download_ipw_1"), # Add the IPW download button here
        download_model_coefficients = mod_download_model_coefficients_ui("download_model_coefficients_1"),
        download_univariate_analysis=mod_download_univariate_analysis_ui("download_univariate_analysis_1"),
        download_smd_analysis=mod_download_smd_analysis_ui("download_smd_analysis_1")
      )
    })
  })

  # Handle navigation back to Page 5 (analysis)
  observeEvent(input$back5, {
    render_analysis_page()  # Ensure the page is rendered properly when going back
  })

  # Handle navigation back to Page 4 (parameters)
  observeEvent(input$back4, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page4_parameters.html"),
                   select_number_of_cv_iterations = mod_select_number_of_cv_iterations_ui("select_number_of_cv_iterations_1"),
                   select_alpha_value = mod_select_alpha_value_ui("select_alpha_value_1"))  # Load Page 4
    })
  })

  # Handle navigation back to Page 3 (outcomes)
  observeEvent(input$back3, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page3_outcomes.html"),
                   select_primary_outcome = mod_select_primary_outcome_ui("select_primary_outcome_1"),
                   select_secondary_outcome = mod_select_secondary_outcome_ui("select_secondary_outcome_1"))  # Load Page 3
    })

    # Call primary outcome server module
    selected_primary_outcome <- mod_select_primary_outcome_server("select_primary_outcome_1")

    # Call secondary outcome server module with primary outcome selection as input
    mod_select_secondary_outcome_server("select_secondary_outcome_1", selected_primary_outcome)
  })

  # Handle navigation back to Page 2 (upload)
  observeEvent(input$back2, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page2_upload.html"),
                   metabolomics_data_upload = mod_metabolomics_upload_ui("metabolomics_upload"),
                   participant_data_upload = mod_participant_upload_ui("participant_upload"),
                   select_one_of_rows_or_columns = mod_metabolite_along_ui("metabolite_along_1"))  # Load Page 2
    })
  })

  # Handle navigation back to Page 1 (welcome)
  observeEvent(input$back1, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page1_welcome.html"))  # Load Page 1
    })
  })

  # Observe when "Back to Home" is clicked
  observeEvent(input$back_to_home, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page0_landing.html"))  # Load Home Page again
    })
  })

  # Set up JavaScript to listen for link clicks and notify Shiny
  session$sendCustomMessage(type = 'init', message = NULL)

  # Call the server logic for the modules using moduleServer
  mod_metabolomics_upload_server("metabolomics_upload")
  mod_participant_upload_server("participant_upload")

  # Call cv_iteration and alpha_value server modules with the necessary dependencies
  mod_select_number_of_cv_iterations_server("select_number_of_cv_iterations_1")
  mod_select_alpha_value_server("select_alpha_value_1")

  # Call primary and secondary outcome server modules with the necessary dependencies
  selected_primary_outcome <- mod_select_primary_outcome_server("select_primary_outcome_1")
  mod_select_secondary_outcome_server("select_secondary_outcome_1", selected_primary_outcome)

  # IPW download functionality
  mod_download_ipw_server("download_ipw_1")

  # Model Coefficients functionality
  mod_download_model_coefficients_server("download_model_coefficients_1")

  # Univariate Analysis functionality
  mod_download_univariate_analysis_server("download_univariate_analysis_1")

  #SMD Analysis
  mod_download_smd_analysis_server("download_smd_analysis_1")

  #Metabolite ID's along
  mod_metabolite_along_server("metabolite_along_1")

}
