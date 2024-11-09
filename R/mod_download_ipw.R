#' download_ipw UI Function
#'
#' @description A shiny Module for downloading Inverse Probability Weights.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_ipw_ui <- function(id) {
ns <- NS(id)
tagList(
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = app_sys("app/www/w3style.css"))),
  # Apply the class directly to the downloadButton
  downloadButton(ns("download_ipw"), "Download Inverse Probability Weights", class = "button")
)
}




#' download_ipw Server Function
#'
#' @noRd
mod_download_ipw_server <- function(id,r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # Download handler for generating and serving the CSV
    output$download_ipw <- downloadHandler(
      filename = function() {
        paste("inverse_probability_weights_", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        # Generate random data (rnorm) for the CSV
        # data <- matrix(rnorm(100), ncol = 10)
        data_with_weights <- r$output()$ip_weights$weight_values
        data <- data_with_weights
        write.csv(data, file, row.names = FALSE)
      }
    )
  })
}

## To be copied in the UI
# mod_download_ipw_ui("download_ipw_1")

## To be copied in the server
# mod_download_ipw_server("download_ipw_1")
