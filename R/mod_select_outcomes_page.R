#' select_outcomes_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_outcomes_page_ui <- function(id) {
  ns <- NS(id)
  htmlTemplate(app_sys("app/www/page3_outcomes.html"))
}

#' select_outcomes_page Server Functions
#'
#' @noRd
mod_select_outcomes_page_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    session$sendCustomMessage("background-color", list(colors = rainbow(10)))


  })
}

## To be copied in the UI
# mod_select_outcomes_page_ui("select_outcomes_page_1")

## To be copied in the server
# mod_select_outcomes_page_server("select_outcomes_page_1")
