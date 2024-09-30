#' get_participant_ids
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_participant_ids <- function(metabolite_ids) {
  colnames(metabolite_ids)[-1]
}
