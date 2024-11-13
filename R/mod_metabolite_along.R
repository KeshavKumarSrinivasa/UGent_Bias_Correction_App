#' metabolite_along UI Function
#'
#' @description A shiny Module for selecting between "Rows" and "Columns".
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_metabolite_along_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Radio button for selecting between "Rows" and "Columns"
    radioButtons(ns("is_transpose_needed"), "",
                 choices = list("Rows" = TRUE, "Columns" = FALSE),
                 selected = TRUE)  # Default selection: "Rows"
  )
}


#' metabolite_along Server Functions
#'
#'
#' @noRd
mod_metabolite_along_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # Reactive expression to track user selection between "Rows" and "Columns"
    selected_option <- reactive({
      input$is_transpose_needed
    })

    return(selected_option)
  })
}


## To be copied in the UI
# mod_metabolite_along_ui("metabolite_along_1")

## To be copied in the server
# mod_metabolite_along_server("metabolite_along_1")
