#' get_weights_new_version
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_weights_new_version <- function(combined_data,
                                    train_data,
                                    primary_outcome,
                                    confounding_bias_variables) {
  weights_new_version <- calculate_new_weights(combined_data,
                                               train_data,
                                               primary_outcome,
                                               confounding_bias_variables)
  return(weights_new_version)
}

calculate_new_weights <- function(combined_data,
                                  train_data,
                                  primary_outcome,
                                  secondary_outcome,
                                  confounding_bias_variables) {
  selection_bias_weights <- calculate_selection_bias_weights(combined_data, train_data, primary_outcome)
  confounding_bias_weights <- calculate_confounding_bias_weights(combined_data,
                                                                 train_data,
                                                                 secondary_outcome,
                                                                 confounding_bias_variables)

  selection_bias_weights_vals <- selection_bias_weights$train_weight_values
  confounding_bias_weights_vals <- confounding_bias_weights$train_weight_values

  new_weights <- selection_bias_weights_vals * confounding_bias_weights

  return(new_weights)
}

calculate_selection_bias_weights <- function(combined_data,
                                             train_data,
                                             primary_outcome) {
  selection_bias_weights <- get_weights(combined_data, train_data, primary_outcome)

  return(selection_bias_weights)
}

calculate_confounding_bias_weights <- function(combined_data,
                                               train_data,
                                               secondary_outcome,
                                               confounding_bias_variables) {
  probability_of_secondary_outcome <- get_probability_of_secondary_outcome(combined_data,
                                                                           train_data,
                                                                           secondary_outcome,
                                                                           confounding_bias_variables)
  confounding_bias_weights <- 1 / probability_of_secondary_outcome

  return(confounding_bias_weights)
}

get_probability_of_secondary_outcome <- function(combined_data,
                                                 train_data,
                                                 secondary_outcome,
                                                 confounding_bias_variables) {
  combined_data <- get_secondary_outcome_as_case_control(combined_data, secondary_outcome)

  # Define the response (secondary outcome)
  y <- combined_data[["secondary_outcome_as_case_control"]]

  # Define the predictors (covariates)
  x <- combined_data %>% select(-all_of(c(
    "secondary_outcome_as_case_control", secondary_outcome
  )))  %>% select(confounding_bias_variables) # Remove the secondary outcome column from predictors


  # Get prediction model that preicts secondary outcome given the confounding variables.
  secondary_outcome_model <- cv.glmnet(x, y, alpha = alpha_val)

  # Get predictions
  probability_secondary_outcome <- glmnet::predict.glmnet(
    secondary_outcome_model,
    newx = x,
    s = c("lambda.min"),
    type = c("response")
  )


  # Create a weights vector:
  # Assign prob_case to participants labeled as "Case" and prob_control to participants labeled as "Control"
  combined_probs <- ifelse(
    combined_data[[secondary_outcome_as_case_control]] == "Case",
    probability_secondary_outcome[, "Case"],
    # Assign prob_case to case-labeled participants
    probability_secondary_outcome[, "Control"]
  )                                           # Assign prob_control to control-labeled participants)

  # Add the combined weights as a new column in the combined_data dataframe
  combined_data_with_weights <- combined_data %>% mutate(weights = 1 / combined_probs)

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


get_secondary_outcome_as_case_control <- function(combined_data, secondary_outcome) {
  make_as_case_control <- function(x) {
    converted_to_integer <- as.integer(as.factor(x))
    ifelse(converted_to_integer == 1, "Case", "Control")
  }

  combined_data <- combined_data %>% mutate(secondary_outcome_as_case_control = make_as_case_control(.data[[secondary_outcome]]))

  return(combined_data)

}
