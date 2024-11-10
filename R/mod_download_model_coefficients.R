#' download_obesity_zip UI Function
#'
#' @description A shiny Module for downloading the `obesity.zip` file.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_obesity_zip_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = app_sys("app/www/w3style.css"))),
    downloadButton(ns("download_obesity_zip"), "Download Obesity .zip", class = "button")
  )
}

#' download_obesity_zip Server Function
#'
#' @noRd
mod_download_obesity_zip_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Debugging: Print to confirm the server function is being called
    cat("Download module server for obesity.zip initialized\n")

    # Download handler for serving the `obesity.zip` file using file.copy()
    output$download_obesity_zip <- downloadHandler(
      filename = function() {
        "obesity.zip"  # The name of the file when downloaded
      },
      content = function(file) {
        # Path to the source ZIP file in the `www` directory
        source_file <- "www/obesity.zip"

        # Debugging: Check if the source file exists
        if (file.exists(source_file)) {
          cat("Source file found: ", source_file, "\n")
          # Copy the file to the location specified by `file`
          if (file.copy(source_file, file, overwrite = TRUE)) {
            cat("File successfully copied to: ", file, "\n")
          } else {
            cat("Error: File copy operation failed.\n")
            stop("File copy operation failed.")
          }
        } else {
          cat("Error: Source file does not exist at path: ", source_file, "\n")
          stop("Source file does not exist at path: ", source_file)
        }
      },
      contentType = "application/zip"  # Specify the MIME type as ZIP
    )
  })
}

## To be copied in the UI
# mod_download_obesity_zip_ui("download_obesity_zip_1")

## To be copied in the server
# mod_download_obesity_zip_server("download_obesity_zip_1")
