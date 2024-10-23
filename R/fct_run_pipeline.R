#' run_pipeline
#'
#' @description Executes the full analysis pipeline: data pre-processing, weight calculation, multivariate analysis,
#'              univariate analysis, and standardized mean difference (SMD) calculation.
#'
#' @param participant_data A data frame containing participant details like age, sex, case/control status, etc.
#' @param metabolite_data A data frame containing metabolite information. May need transposing if metabolite IDs are along the rows.
#' @param primary_outcome The name of the primary outcome variable in the dataset (e.g., case/control status).
#' @param secondary_outcome The name of the secondary outcome variable for univariate analysis and SMD calculation.
#' @param alpha The elastic net mixing parameter (alpha = 1 for Lasso, alpha = 0 for Ridge, 0 < alpha < 1 for Elastic Net).
#' @param cv_iter The number of cross-validation folds to use during multivariate analysis.
#' @param metabolite_ids_are_rows A logical flag indicating whether the metabolite IDs are along the rows. If TRUE, the data is transposed.
#' @param split_ratio The ratio of the data to include in the training set. Defaults to 0.8.
#'
#' @return A list containing the processed data, weights, and results from multivariate, univariate, and SMD analysis.
#'         - 'participant_data_out': The original participant data after processing.
#'         - 'metabolite_data_out': The original metabolite data after processing.
#'         - 'combined_data': The combined dataset after merging participant and metabolite data.
#'         - 'train_data': The training dataset.
#'         - 'test_data': The test dataset.
#'         - 'multivariate_results': Results from the multivariate analysis using glmnet.
#'         - 'univariate_results': Results from univariate logistic regression for each predictor.
#'         - 'smd_results': Results of the standardized mean difference (SMD) analysis.
#'
#' @noRd
run_pipeline <- function(participant_data,
                         metabolite_data,
                         primary_outcome,
                         secondary_outcome,
                         confounding_bias_variables,
                         alpha_val,
                         cv_iter,
                         metabolite_ids_are_rows,
                         split_ratio = 0.8) {
  # Step 1: Pre-process the data
  message("Step 1: Pre-processing the data")
  processed_data <- pre_process(
    participant_data,
    metabolite_data,
    secondary_outcome,
    metabolite_ids_are_rows = FALSE,
    case_control_col = "nafld",
    split_ratio = 0.8
  )

  participant_data_out <- processed_data$participant_data
  metabolite_data_out <- processed_data$metabolite_data
  combined_data <- processed_data$combined_data
  train_data <- processed_data$train
  test_data <- processed_data$test

  # Step 2: Get Weights
  message("Step 2: Getting weights")
  ip_weights <- get_weights_new_version(combined_data, train_data, primary_outcome,secondary_outcome,
                                        confounding_bias_variables)

  # Step 3: Multivariate analysis
  message("Step 3: Performing multivariate analysis")
  message(cv_iter)
  multivariate_results <- perform_multivariate_analysis(
    train_data = train_data,
    test_data = test_data,
    secondary_outcome = secondary_outcome,
    alpha_val = alpha_val,
    cv_iter = cv_iter,
    weights = ip_weights$train_weight_values
  )

  # Step 4: Univariate analysis
  message("Step 4: Performing univariate analysis")
  univariate_results <- perform_univariate_analysis(train_data, metabolite_data_out, secondary_outcome,ip_weights$train_weight_values)

  # Step 5: Standardized mean difference analysis
  message("Step 5: Calculating standardized mean difference")
  smd_results <- calculate_smd_all_covariates(
    participant_data = participant_data,
    train_data_with_weights = ip_weights$data_with_weights,
    secondary_outcome,
    primary_outcome
  )

  # Return processed data
  return(
    list(
      ip_weights = ip_weights,
      multivariate_results = multivariate_results,
      univariate_results = univariate_results,
      smd_results = smd_results
    )
  )
}
