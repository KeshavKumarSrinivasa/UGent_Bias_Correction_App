#' download_model_coefficients UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_model_coefficients_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = app_sys("app/www/w3style.css"))),
    # Apply the class directly to the downloadButton
    downloadButton(ns("download_model_coefficients"), "Download Model Coefficients", class = "button")
  )

}

#' download_model_coefficients Server Functions
#'
#' @noRd
mod_download_model_coefficients_server <- function(id,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # Download handler for generating and serving the CSV
    output$download_model_coefficients <- downloadHandler(
      filename = function() {
        paste("download_model_coefficients_", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        # Generate random data (rnorm) for the CSV
        # data <- matrix(rnorm(100), ncol = 10)
        data <- r$output$analysis_results()$multivariate_results$all_coefficients
        write.csv(data, file, row.names = FALSE)
      }
    )
  })
}

## To be copied in the UI
# mod_download_model_coefficients_ui("download_model_coefficients_1")

## To be copied in the server
# mod_download_model_coefficients_server("download_model_coefficients_1")
