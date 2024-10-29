#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  #Storing the user responses.
  r <- reactiveValues()

  #Storing the current page number.
  currentPage <- reactiveVal("page0")

  # To observe naivgation buttons.
  observeEvent(input$next_page, {
    new_page <- paste0("page", get_page_number(currentPage()) + 1)
    currentPage(new_page)
  })

  observeEvent(input$back, {
    new_page <- paste0("page", max(get_page_number(currentPage()) - 1, 0))
    currentPage(new_page)
  })

  observeEvent(input$back_to_home, {
    new_page <- "page0"
    currentPage(new_page)
  })


  # functions to load the respective pages based on page numbers.
  output$pageContent <- renderUI({
    switch(
      currentPage(),
      "page1" = mod_welcome_page_ui("welcome_page_1"),
      "page2" = mod_upload_data_page_ui("upload_data_page_1"),
      "page3" = mod_select_outcomes_page_ui("select_outcomes_page_1"),
      "page4" = mod_select_parameters_page_ui("select_parameters_page_1"),
      "page5" = mod_analysis_results_page_ui("analysis_results_page_1"),
      "page6" = mod_downloads_page_ui("downloads_page_1"),
      mod_landing_page_ui("landing_page_1")
    )
  })

  observeEvent(currentPage(), {
    switch(
      currentPage(),
      "page1" = mod_welcome_page_server("welcome_page_1"),
      "page2" = mod_upload_data_page_server("upload_data_page_1",r),
      "page3" = mod_select_outcomes_page_server("select_outcomes_page_1",r,currentPage()),
      "page4" = mod_select_parameters_page_server("select_parameters_page_1",r),
      "page5" = mod_analysis_results_page_server("analysis_results_page_1",r),
      "page6" = mod_downloads_page_server("downloads_page_1",r)
    )
  })



}




# # Store the current page number
# current_page <- reactiveVal("page_0")
#
#
# # Switch page_numbers
# observeEvent()
#
#
#
#
# r <- reactiveValues()
#
# # Cache the UI so that it can be reused when navigating back to page 5
# cached_analysis_ui <- reactiveVal()
#
# analysis_values <- reactiveVal()
#
#
#
# # Helper function to render analysis page with the analysis module UI
# render_analysis_page <- function(r) {
#   if (is.null(cached_analysis_ui())) {
#     output$pageContent <- renderUI({
#       htmlTemplate(
#         app_sys("app/www/page5_analysis.html"),
#         display_analysis_results = mod_view_analysis_ui("view_analysis_1")
#       )
#     })
#
#     r$complete_analysis_results <- mod_view_analysis_server("view_analysis_1", r = r)
#     # Use observe or another reactive context to access the reactive value
#
#     observe({
#       req(r$complete_analysis_results())
#       analysis_values(r$complete_analysis_results())
#     })
#
#
#     cached_analysis_ui(TRUE)
#   } else {
#     output$pageContent <- renderUI({
#       htmlTemplate(
#         app_sys("app/www/page5_analysis.html"),
#         display_analysis_results = mod_view_analysis_ui("view_analysis_1")
#       )
#     })
#   }
# }
#
#
#
# # Observe when "Go to Page 1" is clicked
# observeEvent(input$get_started, {
#   output$pageContent <- renderUI({
#     htmlTemplate(app_sys("app/www/page1_welcome.html"))
#   })
# })
#
# # Observe when "continue" is clicked
# observeEvent(input$continue, {
#   output$pageContent <- renderUI({
#     htmlTemplate(
#       app_sys("app/www/page2_upload.html"),
#       metabolomics_data_upload = mod_metabolomics_upload_ui("metabolomics_upload"),
#       participant_data_upload = mod_participant_upload_ui("participant_upload"),
#       select_one_of_rows_or_columns = mod_metabolite_along_ui("metabolite_along_1")
#     )
#   })
# })
#
# # Capture dataset and dataset columns when participant data is uploaded
# r$participant_data <- mod_participant_upload_server("participant_upload")
#
# # Capture dataset and dataset columns when metabolomics data is uploaded
# r$metabolomics_data <- mod_metabolomics_upload_server("metabolomics_upload")
#
# # Capture if metabolites are recorded along rows or columns of the dataset
# r$metabolites_are_rows <- mod_metabolite_along_server("metabolite_along_1")
#
#
# # Handle navigation to Page 3 (outcomes)
# observeEvent(input$next3, {
#   req(r$participant_data$participant_dataset_columns())
#   participant_data_columns <- r$participant_data$participant_dataset_columns()
#
#   # First render the UI
#   output$pageContent <- renderUI({
#     htmlTemplate(
#       app_sys("app/www/page3_outcomes.html")
#     )
#   })
#
#   # Use `shinyjs::runjs` to ensure the message is sent after the page is fully rendered and loaded
#   shinyjs::runjs("
#   Shiny.onInputChange('pageReady', Math.random());
# ")
#
#   # Send custom message only when the client notifies that the page is ready
#   observeEvent(input$pageReady, {
#     print("participant_data_columns")
#     print(participant_data_columns)
#
#     # Now send the custom message after the page is fully loaded
#     session$sendCustomMessage(type = "updateOptions", message = list(options = participant_data_columns))
#   })
# })
#
#
#
#
#
# # Handle navigation to Page 4 (parameters)
# observeEvent(input$next4, {
#   output$pageContent <- renderUI({
#     htmlTemplate(
#       app_sys("app/www/page4_parameters.html")
#     )  # Load Page 4
#   })
# })
#
# # Get the cv_iter value
# observe({
#   # r$cv_iter <- mod_select_number_of_cv_iterations_server("select_number_of_cv_iterations_1")
#   r$cv_iter <- input$cv_iter
#
#   # Get the alpha value
#   # r$alpha <- mod_select_alpha_value_server("select_alpha_value_1")
#   r$alpha <- input$alpha_value
#
# })
#
#
# observe({
#   req(input$fav_language)
#   r$designed_for_another_outcome <- input$fav_language
#   if(r$designed_for_another_outcome){
#
#     r$primary_outcome <- input$secondSelect
#     r$secondary_outcome <- input$firstSelect
#
#   }else{
#     r$primary_outcome <- input$firstSelect
#     r$secondary_outcome <- input$firstSelect
#   }
#
#
#
#   r$confounding_bias_variables <- input$adjust_factors
#   print(r$primary_outcome)
#   print(r$secondary_outcome)
# })
#
# # Handle navigation to Page 5 (view analysis)
# observeEvent(input$next5, {
#   req(
#     r$participant_data$participant_dataset_columns(),
#     r$metabolomics_data$metabolomics_dataset_columns(),
#     r$metabolites_are_rows(),
#     r$primary_outcome,
#     r$secondary_outcome,
#     r$confounding_bias_variables,
#     r$cv_iter,
#     r$alpha
#   )
#   print("The CV Iter is:")
#   print(r$cv_iter)
#
#   print("The alpha value is:")
#   print(r$alpha)
#
#   render_analysis_page(
#     # participant_data_in = r$participant_data,
#     # metabolomics_data_in = r$metabolomics_data,
#     # metabolites_are_rows_in = r$metabolites_are_rows,
#     # selected_primary_outcome_in = selected_primary_outcome,
#     # selected_secondary_outcome_in = selected_secondary_outcome,
#     # cv_iter_in = r$cv_iter,
#     # alpha_in = r$alpha
#     r = r
#   )  # Call the helper function to render the analysis page
# })
#
# # Handle navigation to Page 6 (downloads)
# observeEvent(input$next6, {
#   output$pageContent <- renderUI({
#     htmlTemplate(
#       app_sys("app/www/page6_downloads.html"),
#       download_ipw_button = mod_download_ipw_ui("download_ipw_1"),
#       # Add the IPW download button here
#       download_model_coefficients = mod_download_model_coefficients_ui("download_model_coefficients_1"),
#       download_univariate_analysis = mod_download_univariate_analysis_ui("download_univariate_analysis_1"),
#       download_smd_analysis = mod_download_smd_analysis_ui("download_smd_analysis_1")
#     )
#   })
# })
#
# # Handle navigation back to Page 5 (analysis)
# observeEvent(input$back5, {
#   render_analysis_page()  # Ensure the page is rendered properly when going back
# })
#
# # Handle navigation back to Page 4 (parameters)
# observeEvent(input$back4, {
#   output$pageContent <- renderUI({
#     htmlTemplate(
#       app_sys("app/www/page4_parameters.html"),
#       select_number_of_cv_iterations = mod_select_number_of_cv_iterations_ui("select_number_of_cv_iterations_1"),
#       select_alpha_value = mod_select_alpha_value_ui("select_alpha_value_1")
#     )  # Load Page 4
#   })
# })
#
# # Handle navigation back to Page 3 (outcomes)
# observeEvent(input$back3, {
#   output$pageContent <- renderUI({
#     htmlTemplate(
#       app_sys("app/www/page3_outcomes.html")
#     )  # Load Page 3
#   })
#
#   # Ensure columns are available before initializing modules
#   observe({
#     req(r$participant_data$participant_dataset_columns())  # Ensure dataset columns are available
#
#     # Call the "select outcome of interest" module and capture the selected primary outcome
#     selected_outcome_of_interest <- mod_select_outcome_of_interest_server("select_outcome_of_interest_1", r = r)
#
#     # Call the secondary outcome module and pass the selected primary outcome
#     is_designed_for_another_outcome_input <- mod_is_designed_for_another_outcome_server("is_designed_for_another_outcome_1",
#                                                                                         r = r)
#
#     # Store the selected primary and secondary outcomes in reactive values
#     r$outcome_of_interest <- selected_outcome_of_interest
#     r$designed_for_another_outcome <- is_designed_for_another_outcome_input
#   })
#
# })
#
# # Handle navigation back to Page 2 (upload)
# observeEvent(input$back2, {
#   output$pageContent <- renderUI({
#     htmlTemplate(
#       app_sys("app/www/page2_upload.html"),
#       metabolomics_data_upload = mod_metabolomics_upload_ui("metabolomics_upload"),
#       participant_data_upload = mod_participant_upload_ui("participant_upload"),
#       select_one_of_rows_or_columns = mod_metabolite_along_ui("metabolite_along_1")
#     )  # Load Page 2
#   })
# })
#
# # Handle navigation back to Page 1 (welcome)
# observeEvent(input$back1, {
#   output$pageContent <- renderUI({
#     htmlTemplate(app_sys("app/www/page1_welcome.html"))  # Load Page 1
#   })
# })
#
# # Observe when "Back to Home" is clicked
# observeEvent(input$back_to_home, {
#   output$pageContent <- renderUI({
#     htmlTemplate(app_sys("app/www/page0_landing.html"))  # Load Home Page again
#   })
# })
#
# # Set up JavaScript to listen for link clicks and notify Shiny
# session$sendCustomMessage(type = 'init', message = NULL)
#
# # Call the server logic for the modules using moduleServer
# mod_metabolomics_upload_server("metabolomics_upload")
# mod_participant_upload_server("participant_upload")
#
# # Call primary and secondary outcome server modules
# # selected_primary_outcome <- mod_select_primary_outcome_server("select_primary_outcome_1", r = r)
# # mod_select_secondary_outcome_server("select_secondary_outcome_1", selected_primary_outcome, r = r)
# observe({
#   req(analysis_values())
#
# # IPW download functionality
# mod_download_ipw_server("download_ipw_1",data_with_weights = analysis_values()$ip_weights$data_with_weights)
#
# # Model Coefficients functionality
# mod_download_model_coefficients_server("download_model_coefficients_1",data_model_coefficients = analysis_values()$multivariate_results$all_coefficients)
#
# # Univariate Analysis functionality
# mod_download_univariate_analysis_server("download_univariate_analysis_1",data_univariate_results = analysis_values()$univariate_results$results)
#
# #SMD Analysis
# mod_download_smd_analysis_server("download_smd_analysis_1",data_smd = analysis_values()$smd_results )
# })
#
#   #Metabolite ID's along
#   mod_metabolite_along_server("metabolite_along_1")
# }
