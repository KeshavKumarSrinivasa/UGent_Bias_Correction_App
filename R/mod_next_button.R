#' next_button UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_next_button_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' next_button Server Functions
#'
#' @noRd 
mod_next_button_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_next_button_ui("next_button_1")
    
## To be copied in the server
# mod_next_button_server("next_button_1")
