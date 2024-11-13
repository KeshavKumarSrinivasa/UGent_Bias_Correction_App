#' pre_process
#'
#' @description Pre-processes the data by merging participant and metabolite datasets, optionally transposing the metabolite data,
#'              and then splitting it into training and test sets. Also returns the combined data and the original input dataframes.
#'
#' @param participant_data A data frame containing participant details like age, sex, case/control status, etc.
#' @param metabolite_data A data frame containing metabolite information. May need transposing if metabolite IDs are along the rows.
#' @param metabolite_ids_are_rows A logical flag indicating whether the metabolite IDs are along the rows. If TRUE, the data is transposed.
#' @param case_control_col The name of the column in `participant_data` that contains the case/control labels. Defaults to "case_control".
#' @param split_ratio The ratio of the data to include in the training set. Defaults to 0.8.
#'
#' @return A list containing 'train', 'test', 'combined_data', 'participant_data', and 'metabolite_data'.
#'
#' @noRd
pre_process <- function(participant_data, metabolite_data, primary_outcome, secondary_outcome,metabolite_ids_are_rows = TRUE, case_control_col = "case_control", split_ratio = 0.8) {

  # Transpose metabolite data if metabolite IDs are along the rows
  if (metabolite_ids_are_rows) {
    metabolite_data <- take_transpose(metabolite_data)
  }

  #Store participant_data_columns
  participant_data_columns <- colnames(participant_data)
  columns_to_exclude <- setdiff(participant_data_columns,secondary_outcome)

  if(primary_outcome==secondary_outcome){
    case_control_col <- secondary_outcome
  }else{
    case_control_col <- primary_outcome
  }



  # More concise and specific to metabolite data
  processed_metabolite_data <- preprocess_metabolites_data(metabolite_data)

  # #Impute missing values in Participant Data
  # participant_data <- preprocess_participant_data(participant_data)


  # Merge the two data frames based on 'participant_id'
  # print("$$$$$$$$$$$$$$$$$$$$")
  # print(dim(participant_data))
  # print(dim(processed_metabolite_data))
  # print(dim(metabolite_data))
  # print("$$$$$$$$$$$$$$$$$$$$")
  combined_data <- merge(participant_data, processed_metabolite_data, by = "subjid")
  # print("!!!!!!!!!!!!!!!!!")
  # print(dim(participant_data))
  # print(dim(combined_data))
  # print(setdiff(participant_data[["subjid"]],processed_metabolite_data[["subjid"]]))
  # print(processed_metabolite_data[["subjid"]])
  # print(intersect(participant_data[["subjid"]],processed_metabolite_data[["subjid"]]))
  # print("!!!!!!!!!!!!!!!!!")
  # Make subjid as rownames
  rownames(combined_data) <- combined_data[["subjid"]]
  combined_data <- combined_data[,-c(which(colnames(combined_data)=="subjid"))]




  # Stratified split on case/control status
  set.seed(123)  # For reproducibility
  train_index <- createDataPartition(combined_data[[case_control_col]], p = split_ratio, list = FALSE)

  # Split into train and test sets
  # train_data <- combined_data[train_index, ]
  # test_data <- combined_data[-train_index, ]
  # train_data <- combined_data %>%
  #   select(-any_of(columns_to_exclude)) %>%
  #   filter(rowname %in% train_index) %>%
  #   select(-all_of("rowname"))

  train_data <- combined_data %>%
    select(-any_of(columns_to_exclude))
  train_data <- train_data[train_index,]


  test_data <- combined_data %>%
    select(-any_of(columns_to_exclude))
  test_data <- test_data[-train_index,]

  # print("***********")
  # print("dim(train_data)")
  # print(dim(train_data))
  # print("***********")
  #
  #
  # print("***********")
  # print("dim(test_data)")
  # print(dim(test_data))
  # print("***********")
  # Return all relevant data
  return(list(train = train_data,
              test = test_data,
              combined_data = combined_data,
              participant_data = participant_data,
              metabolite_data = processed_metabolite_data))
}
