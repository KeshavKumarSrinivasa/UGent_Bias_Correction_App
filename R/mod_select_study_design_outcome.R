#' select_study_design_outcome UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_study_design_outcome_ui <- function(id) {
  ns <- NS(id)
  tagList(    selectInput(
    inputId = ns("study_design_outcome"),  # Namespaced ID
    label = "Select the outcome the study was designed for.",  # Label for the dropdown
    choices = NULL  # Choices will be updated dynamically
  )

  )
}

#' select_study_design_outcome Server Functions
#'
#' @noRd
mod_select_study_design_outcome_server <- function(id,outcome_of_interest,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    # Observe the outcome_of_interest and update the study_design_outcome choices
    observe({
      req(outcome_of_interest())  # Ensure primary outcome is selected
      req(r$participant_data$participant_dataset_columns())  # Ensure dataset columns are available

      # Get the list of all outcomes (columns from the dataset)
      all_outcomes <- r$participant_data$participant_dataset_columns()

      # Exclude the selected outcome_of_interest from the study_design_outcome_choices
      study_design_outcome_choices <- setdiff(all_outcomes, outcome_of_interest())

      # Update the choices for the study_design_outcome_choices dropdown
      updateSelectInput(session, ns("study_design_outcome_choices"),
                        choices = study_design_outcome_choices,
                        selected = study_design_outcome_choices[1])  # Default selection (first available)
    })

    # Reactive to return the selected secondary outcome
    selected_study_design_outcome_choice <- reactive({
      input$study_design_outcome_choices
    })

    return(selected_study_design_outcome_choice)
  })
}

## To be copied in the UI
# mod_select_study_design_outcome_ui("select_study_design_outcome_1")

## To be copied in the server
# mod_select_study_design_outcome_server("select_study_design_outcome_1")
