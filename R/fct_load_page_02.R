#' load_page_02
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
load_page_02 <- function() {
  htmlTemplate(
    app_sys("app/www/page2_upload.html"),
    metabolomics_data_upload = mod_metabolomics_upload_ui("metabolomics_upload"),
    participant_data_upload = mod_participant_upload_ui("participant_upload"),
    select_one_of_rows_or_columns = mod_metabolite_along_ui("metabolite_along_1")
  )
}
