#' perform_analysis
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
perform_analysis <- function(r) {

  participant_data = r$input$participant_data()
  metabolomics_data = r$input$metabolomics_data()
  selected_primary_outcome = r$input$selected_actual_outcome_of_interest()
  selected_secondary_outcome = r$input$selected_outcome_of_interest()
  confounding_bias_variables = r$input$covariates_to_adjust()
  alpha_val = r$input$alpha_val()
  cv_iter = r$input$cv_iter()
  metabolites_are_rows = r$input$metabolites_are_rows()

  analysis <- run_pipeline(participant_data = participant_data,
                           metabolite_data = metabolomics_data,
                           primary_outcome = selected_primary_outcome,
                           secondary_outcome =  selected_secondary_outcome,
                           confounding_bias_variables = confounding_bias_variables,
                           alpha_val = alpha_val,
                           cv_iter = cv_iter,
                           metabolite_ids_are_rows = metabolites_are_rows)
  return(analysis)
}
