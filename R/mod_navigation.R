#' navigation UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_navigation_ui <- function(id) {
  ns <- NS(id)

}

#' navigation Server Functions
#'
#' @noRd
mod_navigation_server <- function(id,currentPage){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    print(isolate(currentPage()))

    # Functions to switch to next/back pages.
    observeEvent(input$next_page, {
      print("Next page clicked")
      new_page <- paste0("page", get_page_number(currentPage()) + 1)
      currentPage(new_page)
    })

    observeEvent(input$back, {
      print("Back page clicked")
      new_page <- paste0("page", max(get_page_number(currentPage()) - 1, 0))
      currentPage(new_page)
    })

  })
}

## To be copied in the UI
# mod_navigation_ui("navigation_1")

## To be copied in the server
# mod_navigation_server("navigation_1")
