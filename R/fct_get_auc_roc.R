#' get_auc_roc
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
# Function to evaluate the model using the test data and plot ROC curve
plot_auc_roc <- function(model, test_data, case_control_col = "case_control") {
  # Predict probabilities
  test_prob <- predict(model, newdata = test_data, type = "response")

  # Get true labels
  true_labels <- test_data[[case_control_col]]

  # Plot the ROC curve and calculate AUC
  roc_obj <- roc(as.numeric(true_labels), test_prob)
  auc_value <- auc(roc_obj)

  # Plot the ROC curve
  plot(roc_obj, col = "blue", main = paste("ROC Curve - AUC:", round(auc_value, 2)))

  return(auc_value)
}
