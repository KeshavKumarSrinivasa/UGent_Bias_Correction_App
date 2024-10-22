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
perform_multivariate_analysis <- function(train_data,
                                          test_data,
                                          secondary_outcome,
                                          alpha_val,
                                          cv_iter,
                                          weights = NULL) {

  #Making subject id as rownames
  # rownames(train_data) <- train_data[["subjid"]]
  # train_data <- train_data[,-c(which(colnames(train_data)=="subjid"))]

  # Create model matrix
  x <- model.matrix(as.formula(paste(secondary_outcome, "~ . - 1")), data = train_data)  # Create model matrix (no intercept)
  y <- as.factor(train_data[[secondary_outcome]])  # Outcome variable (factor)

  cv_iter <- as.numeric(cv_iter)
  alpha_val <- as.numeric(alpha_val)

  # Run cross-validated glmnet with weights
  cv_fit <- cv.glmnet(
    x,
    y,
    family = "binomial",
    alpha = alpha_val,
    weights = weights,
    nfolds = cv_iter
  )

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

  # Step 3: Calculate AUC-ROC on the test data
  test_x <- model.matrix(as.formula(paste(secondary_outcome, "~ . - 1")), data = test_data)  # Create model matrix (no intercept)
  test_y <- as.factor(test_data[[secondary_outcome]])  # Outcome variable (factor)
  y_pred <- predict(cv_fit,
                    newx = test_x,
                    s = "lambda.min",
                    type = "response")
  y_pred <- as.vector(y_pred)
  roc_obj <- roc(test_y, y_pred)  # Calculate ROC curve

  # Step 4: Calculate the AUC value and 95% confidence interval for AUC

  auc_value <- ci.auc(roc_obj)[2] # AUC value
  auc_ci <- ci(roc_obj)[c(1,3)] # 95% Confidence interval

  print("******************")
  print(auc_value)

  # Step 5: Calculate confidence intervals for the ROC curve at specific sensitivity levels
  ci <- ci.se(roc_obj, specificities = seq(0, 1, 0.01))

  # Convert the confidence interval object to a dataframe
  ci_df <- data.frame(
    x = as.numeric(rownames(ci)),
    ymin = ci[, 1],
    ymax = ci[, 3]
  )

  # Step 6: Create the ROC plot with confidence bands
  roc_plot <- ggroc(roc_obj, color = "blue") +
    geom_ribbon(data = ci_df, aes(x = x, ymin = ymin, ymax = ymax), fill = "blue", alpha = 0.2) +  # Add confidence bands
    ggtitle(paste("ROC Curve (AUC = ", round(auc_value, 3), ")", sep = "")) +
    theme_minimal() +
    annotate(
      "text",
      x = 0.8,
      y = 0.2,
      label = paste0("AUC 95% CI: (", round(auc_ci[1], 3), ", ", round(auc_ci[2], 3), ")"),
      size = 5,
      hjust = 0
    )


  print(dim(test_data))

  write.csv(coef_df,"all_coefficients.csv")

  # Return the top ten coefficients, AUC value, and the ROC curve plot
  return(
    list(
      top_ten_coefficients = top_ten_coef,
      all_coefficients = coef_df,
      auc_value = auc_value,
      auc_ci = auc_ci,
      roc_plot = roc_plot
    )
  )
}
