#' perform_analysis
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
perform_analysis <- function(r) {

  participant_data <- r$input$participant_data$participant_dataset()
  metabolomics_data <- r$input$metabolomics_data$metabolomics_dataset()
  confounding_bias_variables <- r$input$covariates_to_adjust()
  alpha_val <- r$input$alpha_val() %>%   as.numeric()
  cv_iter  <- r$input$cv_iter() %>% as.numeric()
  metabolites_are_rows <- r$input$metabolites_are_rows()
  valid_participant_dataset_columns <- r$input$participant_data$participant_dataset_columns()

  study_for_another_outcome <- r$input$study_for_another_outcome()
  study_for_another_outcome <-  eval(parse(text = study_for_another_outcome))

  if(study_for_another_outcome){
    selected_primary_outcome <- r$input$selected_actual_outcome_of_interest()
    selected_secondary_outcome <- r$input$selected_outcome_of_interest()
  }else{
    selected_primary_outcome <- selected_secondary_outcome <- r$input$selected_outcome_of_interest()
  }

  selected_secondary_outcome <- r$input$participant_data$participant_dataset_columns()[[selected_secondary_outcome]]

  selected_primary_outcome <- r$input$participant_data$participant_dataset_columns()[[selected_primary_outcome]]

  confounding_bias_variables <- which(confounding_bias_variables %in% r$input$participant_data$actual_participant_dataset_columns())


  analysis <- run_pipeline(participant_data = participant_data,
                           metabolite_data = metabolomics_data,
                           primary_outcome = selected_primary_outcome,
                           secondary_outcome =  selected_secondary_outcome,
                           confounding_bias_variables = confounding_bias_variables,
                           # valid_participant_dataset_columns = valid_participant_dataset_columns,
                           alpha_val = alpha_val,
                           cv_iter = cv_iter,
                           metabolite_ids_are_rows = metabolites_are_rows)
  return(analysis)
}
