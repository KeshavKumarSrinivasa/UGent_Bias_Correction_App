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
        paste("entered_data_", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        if(r$input$study_for_another_outcome()=="FALSE"){
          actual_outcome <- r$input$selected_outcome_of_interest()
        }else{
          actual_outcome <-r$input$selected_actual_outcome_of_interest()
        }

        covariates_to_adjust <- paste(r$input$covariates_to_adjust(),collapse = ", ")
        vec_entered_values <- c(r$input$selected_outcome_of_interest(),r$input$study_for_another_outcome(),actual_outcome,covariates_to_adjust,r$input$alpha_value(),r$input$cv_iter())
        vec_entered_input <- c("Selected Outcome of Interest","Was this study designed for another outcome?","Selected Actual Outcome","Covariates selected for adjusting","Alpha Value","Cross Validation Iterations")

        data <- as.data.frame(list(Entered_Input_Type=vec_entered_input,
                                   Entered_Input_Values=vec_entered_values))
        write.csv(data, file, row.names = FALSE)
      }
    )
  })
}

## To be copied in the UI
# mod_download_entered_data_ui("download_entered_data_1")

## To be copied in the server
# mod_download_entered_data_server("download_entered_data_1")
