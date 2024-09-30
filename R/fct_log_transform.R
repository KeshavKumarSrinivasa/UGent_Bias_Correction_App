#' log_transform
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
log_transform <- function(data) {
  # Apply log10 transformation to all columns except 'subjid'
  data <- data %>%
    mutate(across(-subjid, ~ log10(. + 1)))  # Apply log10 to all columns except 'subjid'

  return(data)
}



