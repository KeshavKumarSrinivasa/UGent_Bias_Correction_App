#' download_complete_report UI Function
#'
#' @description A shiny Module for downloading a complete report.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#'
library(openxlsx)
mod_download_complete_report_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = app_sys("app/www/w3style.css"))),
    # Apply the class directly to the downloadButton
    downloadButton(ns("download_complete_report"), "Download Complete Report", class = "button")
  )
}

#' download_complete_report Server Function
#'
#' @noRd
mod_download_complete_report_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$download_complete_report <- downloadHandler(
      filename = function() {
        paste("complete_report_", format(Sys.time(), "%Y-%m-%d_%H-%M-%S"), ".xlsx", sep = "")
      },
      content = function(file) {
        # Create a workbook object
        wb <- createWorkbook()

        # Collect data for the report
        complete_report <- list(
          entered_input = get_entered_input_data(r),
          ipw_weights = r$output()$ip_weights$data_with_weights,
          multivariate_results = r$output()$multivariate_results$all_coefficients,
          univariate_results = r$output()$univariate_results$results,
          smd_analysis = get_smd_data(r),
          volcano_plot = r$output()$univariate_results$volcano_plot,
          roc_plot = r$output()$multivariate_results$roc_plot
        )

        # Write data and plots to the workbook
        complete_report %>%
          imap(function(x, y) {
            addWorksheet(wb, sheetName = y)
            if (!grepl("plot", y)) {
              # Write data frames or matrices
              writeData(wb, x, sheet = y)
            } else {
              # Plot and insert plots into the worksheet
              plot(x)  # Render the plot
              insertPlot(wb, sheet = y, width = 6, height = 4)  # Adjust width and height as needed
            }
          })

        # Save the workbook to the specified file
        saveWorkbook(wb, file = file, overwrite = TRUE)
      }
    )
  })
}

## To be copied in the UI
# mod_download_complete_report_ui("download_complete_report_1")

## To be copied in the server
# mod_download_complete_report_server("download_complete_report_1")
