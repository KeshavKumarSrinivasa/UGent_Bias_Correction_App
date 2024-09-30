#' analyze
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
# Analyze function: build model, plot ROC, and return AUC
analyze <- function(train_data, test_data, case_control_col = "case_control") {

  # Build logistic regression model (or another type of model)
  model <- glm(as.factor(train_data[[case_control_col]]) ~ ., data = train_data, family = binomial)

  # Predict probabilities on the test set
  test_prob <- predict(model, newdata = test_data, type = "response")

  # Get true labels from the test set
  true_labels <- test_data[[case_control_col]]

  # Calculate ROC and AUC
  roc_obj <- roc(as.numeric(true_labels), test_prob)
  auc_value <- auc(roc_obj)

  # Plot the ROC curve
  plot(roc_obj, col = "blue", main = paste("ROC Curve - AUC:", round(auc_value, 2)))

  return(auc_value)
}
