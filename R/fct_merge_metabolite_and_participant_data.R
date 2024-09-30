#' merge_metabolite_and_participant_data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
merge_metabolite_and_participant_data <- function(metabolite_data,participant_data) {
  merge(participant_data, metabolite_data, by = "participant_id", all = FALSE)
}
