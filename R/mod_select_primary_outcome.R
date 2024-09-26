#' select_primary_outcome UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_primary_outcome_ui <- function(id) {
  ns <- NS(id)
  tagList(

  )
}

#' select_primary_outcome Server Functions
#'
#' @noRd
mod_select_primary_outcome_server <- function(input, output, session){
    ns <- session$ns

}

## To be copied in the UI
# mod_select_primary_outcome_ui("select_primary_outcome_1")

## To be copied in the server
# mod_select_primary_outcome_server("select_primary_outcome_1")
