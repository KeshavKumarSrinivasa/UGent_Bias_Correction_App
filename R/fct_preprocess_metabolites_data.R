#' preprocess_metabolites_data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
preprocess_metabolites_data <- function(data) {

  # Step 1: Log Transform
  data <- log_transform(data)

  # Step 2: Scale
  data <- scale_data(data)

  # Step 3: Remove Columns with Too Many Missing Values
  data <- remove_missing_columns(data)

  # Step 4: Impute Missing Values
  data <- impute_missing_columns(data)

  return(data)
}

