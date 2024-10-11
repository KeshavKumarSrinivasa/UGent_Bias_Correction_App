#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  r <- reactiveValues()

  # Cache the UI so that it can be reused when navigating back to page 5
  cached_analysis_ui <- reactiveVal(NULL)

  analysis_values <- reactiveVal()


  # Helper function to render analysis page with the analysis module UI
  render_analysis_page <- function(r) {
    if (is.null(cached_analysis_ui())) {
      output$pageContent <- renderUI({
        htmlTemplate(
          app_sys("app/www/page5_analysis.html"),
          display_analysis_results = mod_view_analysis_ui("view_analysis_1")
        )
      })

      r$complete_analysis_results <- mod_view_analysis_server("view_analysis_1", r = r)
      # Use observe or another reactive context to access the reactive value

      observe({
        req(r$complete_analysis_results())  # Ensure it's not NULL
        analysis_values(r$complete_analysis_results())  # Access the reactive value using parentheses
        print("Printing in render_analysis_page")
        print(names(analysis_values()))  # Print the names of the list returned by analysis_result
      })


      cached_analysis_ui(TRUE)
    } else {
      output$pageContent <- renderUI({
        htmlTemplate(
          app_sys("app/www/page5_analysis.html"),
          display_analysis_results = mod_view_analysis_ui("view_analysis_1")
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
      htmlTemplate(app_sys("app/www/page1_welcome.html"))
    })
  })

  # Observe when "continue" is clicked
  observeEvent(input$continue, {
    output$pageContent <- renderUI({
      htmlTemplate(
        app_sys("app/www/page2_upload.html"),
        metabolomics_data_upload = mod_metabolomics_upload_ui("metabolomics_upload"),
        participant_data_upload = mod_participant_upload_ui("participant_upload"),
        select_one_of_rows_or_columns = mod_metabolite_along_ui("metabolite_along_1")
      )
    })
  })

  # Capture dataset and dataset columns when participant data is uploaded
  r$participant_data <- mod_participant_upload_server("participant_upload")

  # Capture dataset and dataset columns when metabolomics data is uploaded
  r$metabolomics_data <- mod_metabolomics_upload_server("metabolomics_upload")

  # Capture if metabolites are recorded along rows or columns of the dataset
  r$metabolites_are_rows <- mod_metabolite_along_server("metabolite_along_1")

  # Handle navigation to Page 3 (outcomes)
  observeEvent(input$next3, {
    output$pageContent <- renderUI({
      htmlTemplate(
        app_sys("app/www/page3_outcomes.html"),
        select_primary_outcome = mod_select_primary_outcome_ui("select_primary_outcome_1"),
        select_secondary_outcome = mod_select_secondary_outcome_ui("select_secondary_outcome_1")
      )
    })

    # Ensure columns are available before initializing modules
    observe({
      req(r$participant_data$participant_dataset_columns())  # Ensure dataset columns are available

      # Call the primary outcome module and capture the selected primary outcome
      selected_primary_outcome <- mod_select_primary_outcome_server("select_primary_outcome_1", r = r)

      # Call the secondary outcome module and pass the selected primary outcome
      selected_secondary_outcome <- mod_select_secondary_outcome_server("select_secondary_outcome_1",
                                                                        selected_primary_outcome,
                                                                        r = r)

      # Store the selected primary and secondary outcomes in reactive values
      r$primary_outcome <- selected_primary_outcome
      r$secondary_outcome <- selected_secondary_outcome
    })
  })




  # Handle navigation to Page 4 (parameters)
  observeEvent(input$next4, {
    output$pageContent <- renderUI({
      htmlTemplate(
        app_sys("app/www/page4_parameters.html"),
        select_number_of_cv_iterations = mod_select_number_of_cv_iterations_ui("select_number_of_cv_iterations_1"),
        select_alpha_value = mod_select_alpha_value_ui("select_alpha_value_1")
      )  # Load Page 4
    })
  })

  # Get the cv_iter value
  r$cv_iter <- mod_select_number_of_cv_iterations_server("select_number_of_cv_iterations_1")

  # Get the alpha value
  r$alpha <- mod_select_alpha_value_server("select_alpha_value_1")



  # Handle navigation to Page 5 (view analysis)
  observeEvent(input$next5, {
    req(
      r$participant_data$participant_dataset_columns(),
      r$metabolomics_data$metabolomics_dataset_columns(),
      r$metabolites_are_rows(),
      r$primary_outcome(),
      r$secondary_outcome(),
      r$cv_iter(),
      r$alpha()
    )

    render_analysis_page(
      # participant_data_in = r$participant_data,
      # metabolomics_data_in = r$metabolomics_data,
      # metabolites_are_rows_in = r$metabolites_are_rows,
      # selected_primary_outcome_in = selected_primary_outcome,
      # selected_secondary_outcome_in = selected_secondary_outcome,
      # cv_iter_in = r$cv_iter,
      # alpha_in = r$alpha
      r = r
    )  # Call the helper function to render the analysis page
  })

  # Handle navigation to Page 6 (downloads)
  observeEvent(input$next6, {
    output$pageContent <- renderUI({
      htmlTemplate(
        app_sys("app/www/page6_downloads.html"),
        download_ipw_button = mod_download_ipw_ui("download_ipw_1"),
        # Add the IPW download button here
        download_model_coefficients = mod_download_model_coefficients_ui("download_model_coefficients_1"),
        download_univariate_analysis = mod_download_univariate_analysis_ui("download_univariate_analysis_1"),
        download_smd_analysis = mod_download_smd_analysis_ui("download_smd_analysis_1")
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
      htmlTemplate(
        app_sys("app/www/page4_parameters.html"),
        select_number_of_cv_iterations = mod_select_number_of_cv_iterations_ui("select_number_of_cv_iterations_1"),
        select_alpha_value = mod_select_alpha_value_ui("select_alpha_value_1")
      )  # Load Page 4
    })
  })

  # Handle navigation back to Page 3 (outcomes)
  observeEvent(input$back3, {
    output$pageContent <- renderUI({
      htmlTemplate(
        app_sys("app/www/page3_outcomes.html"),
        select_primary_outcome = mod_select_primary_outcome_ui("select_primary_outcome_1"),
        select_secondary_outcome = mod_select_secondary_outcome_ui("select_secondary_outcome_1")
      )  # Load Page 3
    })

    # Ensure columns are available before initializing modules
    observe({
      req(r$participant_data$participant_dataset_columns())  # Ensure dataset columns are available before calling the primary outcome module

      # Call the primary outcome module
      selected_primary_outcome <- mod_select_primary_outcome_server("select_primary_outcome_1", r = r)

      # Call the secondary outcome module and pass the selected primary outcome
      mod_select_secondary_outcome_server("select_secondary_outcome_1",
                                          selected_primary_outcome,
                                          r = r)
    })
  })

  # Handle navigation back to Page 2 (upload)
  observeEvent(input$back2, {
    output$pageContent <- renderUI({
      htmlTemplate(
        app_sys("app/www/page2_upload.html"),
        metabolomics_data_upload = mod_metabolomics_upload_ui("metabolomics_upload"),
        participant_data_upload = mod_participant_upload_ui("participant_upload"),
        select_one_of_rows_or_columns = mod_metabolite_along_ui("metabolite_along_1")
      )  # Load Page 2
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

  # Call primary and secondary outcome server modules
  # selected_primary_outcome <- mod_select_primary_outcome_server("select_primary_outcome_1", r = r)
  # mod_select_secondary_outcome_server("select_secondary_outcome_1", selected_primary_outcome, r = r)
  observe({
    req(analysis_values())
    print("Printing in Downloads section.")
    print(names(analysis_values()))
  # IPW download functionality
  mod_download_ipw_server("download_ipw_1",data_with_weights = analysis_values()$ip_weights$data_with_weights)

  # Model Coefficients functionality
  mod_download_model_coefficients_server("download_model_coefficients_1",data_model_coefficients = analysis_values()$multivariate_results$all_coefficients)

  # Univariate Analysis functionality
  mod_download_univariate_analysis_server("download_univariate_analysis_1",data_univariate_results = analysis_values()$univariate_results$results)

  #SMD Analysis
  mod_download_smd_analysis_server("download_smd_analysis_1",data_smd = analysis_values()$smd_results )
  })

    #Metabolite ID's along
    mod_metabolite_along_server("metabolite_along_1")
}
