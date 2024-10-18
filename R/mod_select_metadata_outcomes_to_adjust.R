#' select_metadata_outcomes_to_adjust UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_select_metadata_outcomes_to_adjust_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' select_metadata_outcomes_to_adjust Server Functions
#'
#' @noRd 
mod_select_metadata_outcomes_to_adjust_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_select_metadata_outcomes_to_adjust_ui("select_metadata_outcomes_to_adjust_1")
    
## To be copied in the server
# mod_select_metadata_outcomes_to_adjust_server("select_metadata_outcomes_to_adjust_1")
