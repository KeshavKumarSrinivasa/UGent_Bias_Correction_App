#' perform_multivariate_analysis
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
# Multivariate analysis using glmnet (regularized logistic regression)
# Load necessary libraries
library(glmnet)
library(pROC)
library(ggplot2)
library(dplyr)

# Multivariate analysis using glmnet (regularized logistic regression)
perform_multivariate_analysis <- function(train_data, secondary_outcome,alpha, cv_iter, weights = NULL) {
  # Create model matrix
  x <- model.matrix(as.formula(paste(secondary_outcome, "~ . - 1")), data = train_data)  # Create model matrix (no intercept)
  y <- as.factor(train_data$secondary_outcome)  # Outcome variable (factor)



  # Run cross-validated glmnet with weights
  cv_fit <- cv.glmnet(x, y, family = "binomial", alpha = alpha, weights = weights, nfolds = cv_iter)

  # Step 1: Extract the coefficients at the best lambda
  coef_matrix <- coef(cv_fit, s = "lambda.min")
  coef_df <- as.data.frame(as.matrix(coef_matrix))
  coef_df$feature <- rownames(coef_df)
  colnames(coef_df)[1] <- "coefficient"
  coef_df <- coef_df %>% filter(feature != "(Intercept)")  # Remove intercept

  # Step 2: Get the top 10 coefficients by absolute value (excluding intercept)
  top_ten_coef <- coef_df %>%
    arrange(desc(abs(coefficient))) %>%
    head(10)

  # Step 3: Calculate AUC-ROC on the training data
  y_pred <- predict(cv_fit, newx = x, s = "lambda.min", type = "response")
  roc_obj <- roc(y, y_pred)  # Calculate ROC curve

  # Step 4: Calculate the AUC value and 95% confidence interval for AUC
  auc_value <- auc(roc_obj)  # AUC value
  auc_ci <- ci.auc(roc_obj)  # 95% Confidence interval

  # Step 5: Plot ROC curve with ggplot2 and add 95% CI
  roc_plot <- ggroc(roc_obj) +
    geom_line(size = 1) +
    ggtitle(paste("ROC Curve (AUC = ", round(auc_value, 3), ")", sep = "")) +
    theme_minimal() +
    annotate("text", x = 0.8, y = 0.2,
             label = paste0("AUC 95% CI: (",
                            round(auc_ci[1], 3), ", ",
                            round(auc_ci[3], 3), ")"),
             size = 5, hjust = 0)

  # Return the top ten coefficients, AUC value, and the ROC curve plot
  return(list(
    top_ten_coefficients = top_ten_coef,
    auc_value = auc_value,
    auc_ci = auc_ci,
    roc_plot = roc_plot
  ))
}
