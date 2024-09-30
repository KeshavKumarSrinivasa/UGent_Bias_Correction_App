#' impute_missing_columns
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
impute_missing_columns <- function(metabolite_data) {

  # Apply imputation to each numeric column in the dataframe
  metabolite_data <- metabolite_data %>%
    mutate(across(everything(), ~ ifelse(is.na(.), 0.2 * min(., na.rm = TRUE), .)))

  return(metabolite_data)
}

