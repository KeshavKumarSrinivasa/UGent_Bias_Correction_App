#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
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
                   select_one_of_rows_or_columns = 69)  # Load Page 2
    })
  })

  observeEvent(input$next3, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page3_outcomes.html"),
                   select_primary_outcome = 5,
                   select_secondary_outcome = 10)  # Load Page 3
    })
  })

  observeEvent(input$next4, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page4_parameters.html"),
                   select_number_of_cv_iterations = mod_select_number_of_cv_iterations_ui("select_number_of_cv_iterations_1"),
                   select_alpha_value = mod_select_alpha_value_ui("select_alpha_value_1"))  # Load Page 4
    })
  })

  observeEvent(input$next5, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page5_analysis.html"), display_analysis_results = 231)  # Load Page 5
    })
  })

  observeEvent(input$next6, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page6_downloads.html"))  # Load Page 6
    })
  })

  observeEvent(input$back5, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page5_analysis.html"), display_analysis_results = 231)  # Load Page 5
    })
  })

  observeEvent(input$back4, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page4_parameters.html"),
                   select_number_of_cv_iterations = mod_select_number_of_cv_iterations_ui("select_number_of_cv_iterations_1"),
                   select_alpha_value = mod_select_alpha_value_ui("select_alpha_value_1"))  # Load Page 4
    })
  })

  observeEvent(input$back3, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page3_outcomes.html"),
                   select_primary_outcome = 5,
                   select_secondary_outcome = 10)  # Load Page 3
    })
  })

  observeEvent(input$back2, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page2_upload.html"),
                   metabolomics_data_upload = mod_metabolomics_upload_ui("metabolomics_upload"),
                   participant_data_upload = mod_participant_upload_ui("participant_upload"),
                   select_one_of_rows_or_columns = 69)  # Load Page 2
    })
  })

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

  mod_select_number_of_cv_iterations_server("select_number_of_cv_iterations_1")
  mod_select_alpha_value_server("select_alpha_value_1")
}



