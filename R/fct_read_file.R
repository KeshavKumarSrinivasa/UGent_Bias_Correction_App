#' read_file
#'
#' @description A fct function to read an uploaded CSV or Excel file, detecting the separator for CSV files automatically.
#'
#' @param file_path The path to the uploaded file.
#' @param file_ext The file extension (e.g., "csv", "xlsx", "xls").
#'
#' @return A data frame containing the contents of the file.
#' @noRd
read_file <- function(file_path, file_ext) {
  # Load required packages
  library(readr)
  library(readxl)

  # Logic to handle different file types
  if (file_ext == "csv") {
    # Read CSV with automatic separator detection
    file_content <- read_csv_auto(file_path)
  } else if (file_ext %in% c("xlsx", "xls")) {
    # Read Excel file
    file_content <- read_excel(file_path)
  } else {
    stop("Unsupported file type. Please upload a CSV or Excel file.")
  }

  return(file_content)
}

#' Automatically detect the separator in a CSV file
#'
#' @description This function detects the separator (comma, semicolon, tab) in a CSV file and reads it.
#'
#' @param file_path The path to the uploaded CSV file.
#'
#' @return A data frame containing the contents of the CSV file.
#' @noRd
read_csv_auto <- function(file_path) {
  # Read the first few lines to check for potential separators
  first_lines <- readLines(file_path, n = 5)

  # Define potential separators
  separators <- c(",", ";", "\t")

  # Detect the correct separator based on which one splits the first lines correctly
  sep_detected <- separators[which.max(sapply(separators, function(sep) {
    # Count how many columns we get by splitting the first lines
    max(sapply(first_lines, function(line) length(strsplit(line, sep)[[1]])))
  }))]

  # Print for debugging purposes
  message(paste("Detected separator:", sep_detected))

  # Use the detected separator to read the full CSV file
  df <- readr::read_delim(file_path, delim = sep_detected)

  return(df)
}
