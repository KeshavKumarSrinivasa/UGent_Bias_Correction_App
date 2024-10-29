#' study_for_another_outcome UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_study_for_another_outcome_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Yes/No radio button input for the question, mapped to TRUE/FALSE
    radioButtons(
      inputId = ns("is_study_another_outcome"),
      label = "Was this study designed for another outcome?",
      choices = c("Yes" = TRUE, "No" = FALSE),  # Map Yes to TRUE, No to FALSE
      selected = FALSE  # Set "No" as the default
    )
  )
}
#' study_for_another_outcome Server Functions
#'
#' @noRd
mod_study_for_another_outcome_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Reactive to return the TRUE/FALSE response
    study_design_choice <- reactive({
      input$is_study_another_outcome
    })

    # Make study_design_choice accessible outside the module
    return(study_design_choice)
  })
}
## To be copied in the UI
# mod_study_for_another_outcome_ui("study_for_another_outcome_1")

## To be copied in the server
# mod_study_for_another_outcome_server("study_for_another_outcome_1")
