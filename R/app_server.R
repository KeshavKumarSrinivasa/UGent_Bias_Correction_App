#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Load the initial page (Home Page)
  output$pageContent <- renderUI({
    htmlTemplate(app_sys("app/www/index.html"), data_value = 42)  # Insert dynamic value
  })

  # Observe when "Go to Page 2" is clicked
  observeEvent(input$go_to_page2, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/page2.html"), data_value = 99)  # Load Page 2 with dynamic value
    })
  })

  # Observe when "Back to Home" is clicked
  observeEvent(input$back_to_home, {
    output$pageContent <- renderUI({
      htmlTemplate(app_sys("app/www/index.html"), data_value = 48)  # Load Home Page again
    })
  })

  # Set up JavaScript to listen for link clicks and notify Shiny
  session$sendCustomMessage(type = 'init', message = NULL)
  }



