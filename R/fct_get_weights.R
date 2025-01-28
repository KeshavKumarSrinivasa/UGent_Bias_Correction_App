#' get_weights
#'
#' @description This function trains a Random Forest model on the provided dataset, tunes the hyperparameters,
#'              and calculates the weights based on predicted probabilities for cases and controls.
#'
#' @return The train_data dataframe with a new "weights" column containing probabilities.
#'
#' @noRd
library(glmnet)
library(dplyr)
library(ggplot2)

get_weights <- function(combined_data, train_data, primary_outcome) {
  train_indices <- rownames(train_data)
  # Define the response (primary outcome)
  y <- combined_data[,primary_outcome]

  # Convert the response to a binary factor for glmnet (if classification)
  y <- ifelse(y == "Case", 1, 0)  # Binary encoding



  y_train <- combined_data[train_indices,primary_outcome]

  y_train <- ifelse(y_train == "Case", 1, 0)  # Binary encoding




  # Define the predictors (covariates) and remove the primary outcome
  x <- combined_data %>% select(-one_of(primary_outcome))
  x_train <- x[train_indices,]
  x <- as.matrix(x)  # Convert to matrix for glmnet
  x_train <- as.matrix(x_train)
  # Split the test data
  # test_indices <- rownames(combined_data) %in% rownames(test_data)


  # Define a sequence of alpha and lambda values for fine-tuning
  alpha_values <- seq(0, 1, by = 0.1)  # Mix of LASSO (1) and Ridge (0)
  lambda_values <- 10^seq(-3, 1, length.out = 100)  # Lambda grid

  # Fine-tune glmnet with cross-validation
  cv_results <- lapply(alpha_values, function(alpha) {
    cv.glmnet(
      x_train, y_train,
      alpha = alpha,
      lambda = lambda_values,
      family = "binomial",  # Logistic regression for classification
      type.measure = "auc"
    )
  })

  # Choose the best alpha and lambda based on cross-validation AUC
  best_alpha_idx <- which.max(sapply(cv_results, function(cv) max(cv$cvm)))
  best_model <- cv_results[[best_alpha_idx]]
  best_alpha <- alpha_values[best_alpha_idx]
  best_lambda <- best_model$lambda.min

  # Train the final model using the best hyperparameters
  final_model <- glmnet(
    x_train, y_train,
    alpha = best_alpha,
    lambda = best_lambda,
    family = "binomial"
  )

  # Predict probabilities on the full dataset
  prob_predictions <- predict(final_model, x, type = "response")

  # Assign weights based on probabilities
  combined_probs <- ifelse(
    y == 1, prob_predictions, 1 - prob_predictions
  )

  combined_data_with_weights <- combined_data %>%
    mutate(weights = 1 / combined_probs)
    # mutate(is_test = test_indices)

  # # Prepare the data for plotting
  # data <- data.frame(
  #   y = combined_data_with_weights$weights,
  #   x = 0,  # Dummy variable for visualization
  #   train_or_test = combined_data_with_weights$is_test
  # )
  #
  # # Plot weights
  # print(ggplot(data, aes(x = x, y = y, color = train_or_test)) +
  #         geom_point() +
  #         labs(title = "Participant Weights", x = "Dummy Variable", y = "Weights") +
  #         theme_minimal())



  # Filter to match the rows in train_data with weights
  train_data_with_weights <- combined_data_with_weights %>% filter(rownames(.) %in% rownames(train_data))

  # Return the modified train_data dataframe with weights added
  return(
    list(
      train_weight_values = train_data_with_weights[["weights"]],
      train_data_with_weights = train_data_with_weights,
      data_with_weights = combined_data_with_weights,
      weight_values = combined_data_with_weights[["weights"]]
    )
  )
}
