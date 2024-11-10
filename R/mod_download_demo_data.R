#' download_demo_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_demo_data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Reference CSS file directly from the `www` folder without `app_sys()`
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = app_sys("app/www/w3style.css"))),
    downloadButton(ns("download_zip"), "Download Demo Data .zip", class = "button")  # Added ns() to ID
  )
}

#' download_demo_data Server Function
#'
#' @noRd
mod_download_demo_data_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    output$download_zip <- downloadHandler(
      filename = function() { "obesity.zip" },  # Specify the name for the downloaded file
      content = function(file) {
        fs::file_copy("www/obesity.zip", file, overwrite = TRUE)

      },
      contentType = "application/zip"
    )
  })
}

## To be copied in the UI
# mod_download_demo_data_ui("download_demo_data_1")

## To be copied in the server
# mod_download_demo_data_server("download_demo_data_1")
