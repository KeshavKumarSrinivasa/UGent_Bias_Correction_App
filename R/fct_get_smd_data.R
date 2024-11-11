#' get_smd_data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_smd_data <- function(r) {
  data_a <- r$output()$smd_results$smd_after
  data_a <- data_a %>% rename(smd_value = smd_value_after)
  data_a["weighting_status"] <- "after"

  data_b <- r$output()$smd_results$smd_before
  data_b <- data_b %>% rename(smd_value = smd_value_before)
  data_b["weighting_status"] <- "before"

  data <- rbind(data_a,data_b)
  return(data)
}
