#' prediction_using_random_forest
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
prediction_using_random_forest <- function() {
  # Define a reasonable hyperparameter grid for a dataset with many features
  tune_grid <- expand.grid(
    mtry = c(10, 50, 100, 200)  # Number of features considered at each split
  )

  # Cross-validation control: 3-fold CV for faster performance on large datasets
  control <- trainControl(
    method = "cv",                  # Use cross-validation
    number = 3,                     # Number of folds in cross-validation
    classProbs = TRUE,              # For classification problems, calculate class probabilities
    summaryFunction = twoClassSummary  # Optimize based on AUC (ROC curve)
  )

  # Train the random forest model with hyperparameter tuning
  rf_model <- train(
    as.formula(paste(primary_outcome, "~ .")),  # Use the primary outcome dynamically
    data = combined_data,                      # Training dataset
    method = "rf",                             # Random Forest model
    tuneGrid = tune_grid,                      # Hyperparameter grid
    trControl = control,                       # Cross-validation settings
    metric = "ROC"                             # Optimize for AUC (ROC curve)
  )

  # Get predicted probabilities for both case and control classes
  prob_predictions <- predict(rf_model, x, type = "prob")

  # Create a weights vector:
  # Assign prob_case to participants labeled as "Case" and prob_control to participants labeled as "Control"
  combined_probs <- ifelse(
    combined_data[[primary_outcome]] == "Case", prob_predictions[, "Case"], # Assign prob_case to case-labeled participants
    prob_predictions[, "Control"]                                           # Assign prob_control to control-labeled participants
  )

  # Add the combined weights as a new column in the combined_data dataframe
  combined_data_with_weights <- combined_data %>% mutate(weights = 1 / combined_probs)


}
