#' participant_columns_to_adjust UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_participant_columns_to_adjust_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Checkbox group input for selecting columns to adjust for
    checkboxGroupInput(
      inputId = ns("columns_to_adjust"),
      label = "",
      choices = NULL  # Choices will be populated dynamically
    )
  )
}
#' participant_columns_to_adjust Server Functions
#'
#' @noRd
mod_participant_columns_to_adjust_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    list_of_checkboxes <- reactive({
      req(r$input$participant_data$participant_dataset_columns())
      req(r$input$selected_outcome_of_interest())
      req(r$input$study_for_another_outcome())
      req(r$input$selected_actual_outcome_of_interest())
      t9 <- r$input$study_for_another_outcome()
      t10 <- eval(parse(text=t9))
      t11 <- r$input$participant_data$participant_dataset_columns()
      t12 <- r$input$selected_actual_outcome_of_interest()
      t13 <- r$input$selected_outcome_of_interest()

      if(t10){
        t14 <- c(t12,t13)
        t15 <- setdiff(t11,t14)
        return(t15)
      }else{
        t16 <- setdiff(t11,t13)
        return(t16)
      }
    })


    # Observe for changes in required inputs and update checkbox choices
    observe({
      req(list_of_checkboxes())


      # Update the checkbox group with the calculated remaining choices
      updateCheckboxGroupInput(session, "columns_to_adjust", choices = list_of_checkboxes())
    })

    # Store selected columns in r$input for access outside the module
    r$input$covariates_to_adjust <- reactive({
      req(input$columns_to_adjust)
      input$columns_to_adjust
    })
  })
}
## To be copied in the UI
# mod_participant_columns_to_adjust_ui("participant_columns_to_adjust_1")

## To be copied in the server
# mod_participant_columns_to_adjust_server("participant_columns_to_adjust_1")
