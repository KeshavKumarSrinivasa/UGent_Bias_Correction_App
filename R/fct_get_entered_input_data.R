#' get_entered_input_data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_entered_input_data <- function(r) {
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

  return(data)
}
