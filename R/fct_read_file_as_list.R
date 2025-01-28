#' read_file_as_list
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd

library(readxl)
read_file_as_list <- function(file_path, file_extension) {


  # Get the sheet names
  sheet_names <- excel_sheets(file_path)

  # Read each sheet into a list of data frames
  data_list <- lapply(sheet_names, function(sheet) {
    read_excel(file_path, sheet = sheet)
  })

  # Assign sheet names as names of the list elements
  names(data_list) <- sheet_names

  return(data_list)

}
