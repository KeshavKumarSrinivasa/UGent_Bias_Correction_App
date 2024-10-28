#' welcome_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_welcome_page_ui <- function(id) {
  ns <- NS(id)
  htmlTemplate(app_sys("app/www/page1_welcome.html"))
}

#' welcome_page Server Functions
#'
#' @noRd
mod_welcome_page_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_welcome_page_ui("welcome_page_1")

## To be copied in the server
# mod_welcome_page_server("welcome_page_1")
