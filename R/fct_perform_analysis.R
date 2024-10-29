#' perform_analysis
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
perform_analysis <- function(r) {
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
