#' download_entered_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_entered_data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = app_sys("app/www/w3style.css"))),
    # Apply the class directly to the downloadButton
    downloadButton(ns("download_entered_data"), "Download Entered Data", class = "button")
  )
}

#' download_entered_data Server Functions
#'
#' @noRd
mod_download_entered_data_server <- function(id,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # Download handler for generating and serving the CSV
    output$download_entered_data <- downloadHandler(
      filename = function() {
        paste("entered_data_", Sys.time(), ".csv", sep = "")
      },
      content = function(file) {
        data <- get_entered_input_data(r)
        write.csv(data, file, row.names = FALSE)
      }
    )
  })
}

## To be copied in the UI
# mod_download_entered_data_ui("download_entered_data_1")

## To be copied in the server
# mod_download_entered_data_server("download_entered_data_1")
