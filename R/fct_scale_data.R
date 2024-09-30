#' scale_data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
scale_data <- function(data) {
  # Remove the 'subjid' column from data and apply scaling to all columns

  data <- data %>%
    mutate(across(-subjid, ~ as.numeric(scale(.))))  # Apply scale to all remaining columns

  return(data)
}

