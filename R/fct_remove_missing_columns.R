#' remove_missing_columns
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
remove_missing_columns <- function(metabolite_data) {
  # Define the threshold for missing values (20%)
  threshold_missing_values <- nrow(metabolite_data) * 0.2

  # Initialize an empty data frame to store columns with acceptable missing values
  filtered_metabolite_data <- metabolite_data[, colSums(is.na(metabolite_data)) <= threshold_missing_values]

  return(filtered_metabolite_data)
}
