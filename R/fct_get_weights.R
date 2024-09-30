#' get_weights
#'
#' @description This function trains a Random Forest model on the provided dataset, tunes the hyperparameters,
#'              and calculates the weights based on predicted probabilities for cases and controls.
#'
#' @return The train_data dataframe with a new "weights" column containing probabilities.
#'
#' @noRd
library(randomForest)
library(caret)
library(dplyr)

# Function to get weights where prob_case is assigned to cases and prob_control to controls
get_weights <- function(train_data, primary_outcome) {

  # Define the response (primary outcome)
  y <- train_data[[primary_outcome]]

  # Define the predictors (covariates and secondary outcome)
  x <- train_data %>% select(-one_of(primary_outcome))  # Remove the primary outcome column from predictors

  # Define a reasonable hyperparameter grid for a dataset with many features
  tune_grid <- expand.grid(
    mtry = c(10, 50, 100, 200)  # Number of features considered at each split
  )

  # Cross-validation control: 3-fold CV for faster performance on large datasets
  control <- trainControl(
    method = "cv",               # Use cross-validation
    number = 3,                  # Number of folds in cross-validation
    classProbs = TRUE,           # For classification problems, calculate class probabilities
    summaryFunction = twoClassSummary  # Optimize based on AUC (ROC curve)
  )

  # Train the random forest model with hyperparameter tuning
  rf_model <- train(
    as.formula(paste(primary_outcome, "~ .")),  # Use the primary outcome dynamically
    data = train_data,                         # Training dataset
    method = "rf",                             # Random Forest model
    tuneGrid = tune_grid,                      # Hyperparameter grid
    trControl = control,                       # Cross-validation settings
    metric = "ROC"                             # Optimize for AUC (ROC curve)
  )


  # Get predicted probabilities for both case and control classes
  prob_predictions <- predict(rf_model, x, type = "prob")

  # Create a weights vector:
  # Assign prob_case to participants labeled as "case" and prob_control to participants labeled as "control"
  combined_probs <- ifelse(train_data[[primary_outcome]] == "Case",
                             prob_predictions[, "Case"],     # Assign prob_case to case-labeled participants
                             prob_predictions[, "Control"])  # Assign prob_control to control-labeled participants

  # Add the combined weights as a new column in the train_data dataframe
  train_data_with_weights <- train_data %>%
    mutate(weights = 1/combined_probs)

  # Return the modified train_data dataframe with weights added
  return(list(values=weights,train_data_with_weights=train_data_with_weights))
}
