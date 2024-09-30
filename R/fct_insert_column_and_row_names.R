#' insert_column_and_row_names
#'
#' @description Inserts participant IDs as the first column and assigns metabolite IDs to column names.
#'
#' @return The transposed matrix with proper row and column names.
#'
#' @noRd
insert_column_and_row_names <- function(metabolite_transposed_matrix, metabolite_ids, participant_ids) {

  # Convert the transposed matrix to a tibble
  metabolite_transposed_matrix <- as_tibble(metabolite_transposed_matrix)

  # Add the participant IDs as a new column at the beginning
  metabolite_transposed_matrix <- cbind(participant_id = participant_ids, metabolite_transposed_matrix)

  # Assign column names (participant_id for the first column, then metabolite IDs)
  colnames(metabolite_transposed_matrix) <- c("participant_id", metabolite_ids)

  # Return the modified tibble
  return(metabolite_transposed_matrix)
}
