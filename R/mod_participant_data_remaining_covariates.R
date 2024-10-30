#' participant_data_remaining_covariates UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_participant_data_remaining_covariates_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Dropdown for remaining covariates, only displayed if show_dropdown is TRUE
    selectInput(
      inputId = ns("remaining_covariates"),
      label = "What was the study designed for?",
      choices = NULL,  # Placeholder choices; update dynamically in server
      selected = NULL
    )
  )
}


#' participant_data_remaining_covariates Server Functions
#'
#' @noRd
mod_participant_data_remaining_covariates_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Define each input as a reactive expression if they are reactive sources
    participant_data_columns <- reactive({
      req(r$input$participant_data$participant_dataset_columns)
      r$input$participant_data$participant_dataset_columns()
    })

    selected_outcome <- reactive({
      req(r$input$selected_outcome_of_interest)
      r$input$selected_outcome_of_interest()
    })

    show_dropdown <- reactive({
      req(r$input$study_for_another_outcome)
      r$input$study_for_another_outcome()
    })


    # Observe and update dropdown choices when conditions are met
    observeEvent(show_dropdown(),{
      req(participant_data_columns(), selected_outcome(), show_dropdown())
      display_dropdown <- eval(parse(text = show_dropdown()))
      if (display_dropdown) {
        # Update dropdown choices excluding the selected outcome
        remaining_choices <- setdiff(participant_data_columns(), selected_outcome())
        print("In 1")
      }else{
        remaining_choices <- c()
        print("In 2")
      }
      r$input$remaining_choices_for_primary_outcome <- remaining_choices
      print(":::::::::::::::")
      print(r$input$remaining_choices_for_primary_outcome)
      print(":::::::::::::::")
      updateSelectInput(session, "remaining_covariates", choices = r$input$remaining_choices_for_primary_outcome)
    })

    observeEvent(selected_outcome(),{
      req(participant_data_columns(), selected_outcome(), show_dropdown())
      display_dropdown <- eval(parse(text = show_dropdown()))
      if (display_dropdown) {
        # Update dropdown choices excluding the selected outcome
        remaining_choices <- setdiff(participant_data_columns(), selected_outcome())
        print("In 11")
      }else{
        remaining_choices <- c()
        print("In 22")
      }
      r$input$remaining_choices_for_primary_outcome <- remaining_choices
      print(":::::::::::::::")
      print(r$input$remaining_choices_for_primary_outcome)
      print(":::::::::::::::")
      updateSelectInput(session, "remaining_covariates", choices = r$input$remaining_choices_for_primary_outcome)
    })



    # Reactive expression to return the selected covariate
    selected_covariate <- reactive({
      req(eval(parse(text = show_dropdown())))  # Only return if dropdown is visible
      input$remaining_covariates
    })

    # r$input$remaining_choices_for_primary_outcome <- reactive({
    #   req(selected_covariate())  # Only return if dropdown is visible
    #   remaining_choices <- setdiff(participant_data_columns(),selected_covariate())
    #   remaining_choices
    # })

    # Assign the selected covariate to r$input
    r$input$selected_remaining_outcome_of_interest <- reactive({
      req(selected_covariate())
      selected_covariate()
    })
  })
}
## To be copied in the UI
# mod_participant_data_remaining_covariates_ui("participant_data_remaining_covariates_1")

## To be copied in the server
# mod_participant_data_remaining_covariates_server("participant_data_remaining_covariates_1")
