#' select_parameters_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_parameters_page_ui <- function(id) {
  ns <- NS(id)
  htmlTemplate(app_sys("app/www/page4_parameters.html"))
}

#' select_parameters_page Server Functions
#'
#' @noRd
mod_select_parameters_page_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_select_parameters_page_ui("select_parameters_page_1")

## To be copied in the server
# mod_select_parameters_page_server("select_parameters_page_1")
