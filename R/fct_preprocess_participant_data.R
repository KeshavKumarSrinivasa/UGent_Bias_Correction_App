#' preprocess_participant_data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
preprocess_participant_data <- function(input_data) {
  # Impute functions for factors and numeric columns
  impute_factors <- function(x) {
    if (any(is.na(x))) {
      # Get the most common level (mode) to replace NA values
      imputed_value <- names(which.max(table(x, useNA = "no")))
      x[is.na(x)] <- imputed_value
    }
    return(x)
  }

  impute_numeric <- function(x) {
    if (any(is.na(x))) {
      x[is.na(x)] <- mean(x, na.rm = TRUE)
    }
    return(x)
  }

  # Convert character columns (excluding `subjid`) to factors
  input_data <- input_data %>%
    mutate(across(where(is.character) & !all_of("subjid"), as.factor))

  # Impute numeric columns (excluding `subjid`)
  input_data <- input_data %>%
    mutate(across(where(is.numeric) & !all_of("subjid"), impute_numeric))

  # Impute factor columns (excluding `subjid`)
  input_data <- input_data %>%
    mutate(across(where(is.factor) & !all_of("subjid"), impute_factors))
  return(input_data)
}
