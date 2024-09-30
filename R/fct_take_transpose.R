#' take_transpose
#'
#' @description Transposes the metabolite data, ensuring the appropriate assignment of row and column names.
#'
#' @return A tibble with the transposed metabolite data, where the metabolite IDs are the column names, and participant IDs are the row names.
#'
#' @noRd
take_transpose <- function(metabolite_data) {

  # Ensure the data is in tibble format
  metabolite_data <- as_tibble(metabolite_data)

  # Extract metabolite IDs from the first column
  metabolite_ids <- get_metabolite_columns(metabolite_data)

  # Extract participant IDs (column names)
  participant_ids <- get_participant_ids(metabolite_data)

  # Convert the metabolite data (excluding IDs) into a matrix
  metabolite_data_matrix <- get_matrix_from_data(metabolite_data)

  # Transpose the matrix
  metabolite_data_matrix_transpose <- get_transpose_of_matrix(metabolite_data_matrix)

  # Insert row and column names into the transposed matrix
  metabolite_data_transposed <- insert_column_and_row_names(
    metabolite_data_matrix_transpose,
    metabolite_ids,
    participant_ids
  )

  # Explicitly return the transposed data
  return(metabolite_data_transposed)
}
