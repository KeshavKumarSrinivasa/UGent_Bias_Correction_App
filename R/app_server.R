#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Initially load the landing page (page0_landing.html)
  output$pageContent <- renderUI({
    includeHTML(app_sys("app/www/page0_landing.html"))
  })

  # Observe the "Get Started" button click in page0_landing.html
  observeEvent(input$get_started, {
    output$pageContent <- renderUI({
      includeHTML(app_sys("app/www/page1_welcome.html"))  # Load page1.html when button is clicked
    })
  })

  # Observe the "Back to Landing Page" button click in page1.html
  observeEvent(input$back_to_landing, {
    output$pageContent <- renderUI({
      includeHTML(app_sys("app/www/page0_landing.html"))  # Load the landing page again
    })
  })
}



