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
      label = "",
      choices = c("Yes" = TRUE, "No" = FALSE),  # Map Yes to TRUE, No to FALSE
      selected = NULL  # Set "No" as the default
    )
  )
}
#' study_for_another_outcome Server Functions
#'
#' @noRd
mod_study_for_another_outcome_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    r$input$study_for_another_outcome <- reactive({
      req(input$is_study_another_outcome)
      study_for_another_outcome <- input$is_study_another_outcome
      study_for_another_outcome
    })
  })
}
## To be copied in the UI
# mod_study_for_another_outcome_ui("study_for_another_outcome_1")

## To be copied in the server
# mod_study_for_another_outcome_server("study_for_another_outcome_1")
