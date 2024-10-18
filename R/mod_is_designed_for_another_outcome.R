#' is_designed_for_another_outcome UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_is_designed_for_another_outcome_ui <- function(id) {
  ns <- NS(id)
  tagList(
    radioButtons(ns("is_designed_for_another_outcome"),"",
                 choices = list("Yes"=TRUE,"No"=FALSE),
                 selected = TRUE)
  )
}

#' is_designed_for_another_outcome Server Functions
#'
#' @noRd
mod_is_designed_for_another_outcome_server <- function(id, r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns


    # Reactive expression to track user selection between "Yes" and "No"
    selected_option <- reactive({
      input$is_designed_for_another_outcome
    })

    return(selected_option)

  })
}

## To be copied in the UI
# mod_is_designed_for_another_outcome_ui("is_designed_for_another_outcome_1")

## To be copied in the server
# mod_is_designed_for_another_outcome_server("is_designed_for_another_outcome_1")
