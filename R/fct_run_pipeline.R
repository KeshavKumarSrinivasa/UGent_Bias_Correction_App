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
run_pipeline <- function(participant_data, metabolite_data, primary_outcome, secondary_outcome, alpha, cv_iter, metabolite_ids_are_rows, split_ratio = 0.8) {

  # Step 1: Pre-process the data
  processed_data <- pre_process(participant_data, metabolite_data, metabolite_ids_are_rows, split_ratio)

  # Access individual data frames from the pre-processed output
  # 'participant_data_out' and 'metabolite_data_out' are the original datasets after processing,
  # 'combined_data' is the merged dataset, and 'train_data'/'test_data' are the split datasets.
  participant_data_out <- processed_data$participant_data
  metabolite_data_out <- processed_data$metabolite_data
  combined_data <- processed_data$combined_data
  train_data <- processed_data$train
  test_data <- processed_data$test


  # Step 2: Get Weights (if applicable, based on outcomes)
  ip_weights <- get_weights(train_data, primary_outcome)

  # # Add weights to the train_data
  # train_data_with_weights <- train_data %>%
  #   mutate(weights = weights)
  #
  # Step 3: Multivariate analysis (using glmnet with cross-validation)
  multivariate_results <- perform_multivariate_analysis(train_data, alpha, cv_iter, weights = ip_weights$weights)

  # Step 4: Univariate analysis (logistic regression for each predictor)
  univariate_results <- perform_univariate_analysis(train_data_with_weights, secondary_outcome)

  # Step 5: Standardized mean difference analysis
  smd_results <- calculate_smd_secondary_outcome(train_data_with_weights, primary_outcome, secondary_outcome)

  #Return all results
  return(list(
    processed_data = processed_data,
    multivariate_results = multivariate_results,
    univariate_results = univariate_results,
    smd_results = smd_results
  ))

  return(processed_data)
}
