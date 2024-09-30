#' get_train_and_test
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_train_and_test <- function(metabolite_data,participant_data) {
  library(caret)  # for stratified split
  library(dplyr)  # for data manipulation

  # Combine participant data and metabolite data (assuming rows align)
  combined_data <- merge_metabolite_and_participant_data(metabolite_data,
                                                         participant_data)

  # Ensure 'case_control' is the variable with case/control labels
  # Perform stratified split based on 'case_control' column
  set.seed(123)  # For reproducibility
  train_index <- createDataPartition(combined_data$case_control, p = 0.8, list = FALSE)

  # Create train and test sets
  train_data <- combined_data[train_index, ]
  test_data <- combined_data[-train_index, ]

  # Check the proportion of cases and controls in both sets
  table(train_data$case_control)
  table(test_data$case_control)

  return(list(train = train_data, test = test_data))

}
