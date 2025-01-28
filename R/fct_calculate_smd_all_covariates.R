#' calculate_smd
#'
#' @description Calculates Standardized Mean Differences (SMD) for all covariates (both continuous and categorical),
#'              comparing cases and controls before and after applying weights.
#'
#' @param participant_data A data frame that includes the participant data
#' @param primary_outcome The column name of the primary outcome (typically "case" or "control").
#' @param secondary_outcome The secondary outcome of interest (used in SMD calculations).
#' @param weights A vector that has weights for each participant.
#' @param covariates A vector of covariate names for which the SMD is calculated.
#'
#' @return A list with two data frames: 'smd_before' (SMD before applying weights) and 'smd_after' (SMD after applying weights).
#'
#' @noRd

# Load necessary libraries
library(dplyr)

# Function to calculate SMD with respect to secondary outcome for all covariates
calculate_smd_all_covariates <- function(participant_data, train_data_with_weights, secondary_outcome,primary_outcome,secondary_outcome_case,secondary_outcome_control) {

  covariates <- participant_data %>% select(-c(subjid,secondary_outcome)) %>% colnames()

  weights_values <- train_data_with_weights[,"weights"]

  participant_columns <- covariates
  participant_train_data <- train_data_with_weights %>% select(c(any_of(participant_columns),secondary_outcome,weights))
  participant_train_data <- participant_train_data %>%  mutate(across(all_of(covariates), ~ if (is.factor(.)){ as.integer(.) }else{.}))

  # print(participant_train_data[["Smoking.Status"]])

  # Helper function to calculate SMD for continuous variables
  # SMD = |mean_case - mean_control| / sqrt((var_case + var_control) / 2)
  smd_continuous <- function(mean_case, mean_control, var_case, var_control) {
    abs(mean_case - mean_control) / sqrt((var_case + var_control) / 2)
  }

  # Helper function to calculate SMD for categorical variables using proportions
  # SMD = |p_case - p_control| / sqrt((p_case * (1 - p_case) + p_control * (1 - p_control)) / 2)
  smd_proportions <- function(p_case, p_control) {
    abs(p_case - p_control) / sqrt(((p_case * (1 - p_case)) + (p_control * (1 - p_control))) / 2)
  }

  # Initialize data frames to store SMD results before and after weighting
  smd_before <- data.frame(covariate = character(), smd_value = numeric(), stringsAsFactors = FALSE)
  smd_after <- data.frame(covariate = character(), smd_value = numeric(), stringsAsFactors = FALSE)

  participant_train_data <- participant_train_data %>%
    mutate(
      sex = as.integer(as.factor(sex)),
      nafld = as.integer(as.factor(nafld))
    )
  # char_to_integer <- function(x){
  #   as.integer(as.factor(x))
  # }
  # participant_train_data <- participant_train_data %>%
  #   mutate(across(where(is.character), char_to_integer))

  print(head(participant_train_data))
  # Loop through each covariate to calculate SMD before and after weighting
  for (covariate in covariates) {
    print("Working on")
    print(covariate)

    # Check if the covariate is continuous (numeric) or categorical
    # if (!is.numeric(participant_train_data[[covariate]])) {
    #   participant_train_data[[covariate]] <- as.integer(as.factor(participant_train_data[[covariate]]))
    # }
    if(TRUE){

      # Filter case and control groups
      if(secondary_outcome==primary_outcome){
        # case_data <- participant_train_data %>% filter(.data[[secondary_outcome]] == "Case")
        # control_data <- participant_train_data %>% filter(.data[[secondary_outcome]] == "Control")
        case_data <- participant_train_data %>% filter(.data[[secondary_outcome]] == secondary_outcome_case)
        control_data <- participant_train_data %>% filter(.data[[secondary_outcome]] == secondary_outcome_control)
      }else{

        case_data <- participant_train_data %>% filter(.data[[secondary_outcome]] == secondary_outcome_case)
        control_data <- participant_train_data %>% filter(.data[[secondary_outcome]] == secondary_outcome_control)
      }

      # Continuous covariate: Calculate SMD using means and variances


      # SMD before weighting: Calculate mean and variance for cases and controls
      mean_case <- mean(case_data[[covariate]], na.rm = TRUE)
      mean_control <- mean(control_data[[covariate]], na.rm = TRUE)
      var_case <- var(case_data[[covariate]], na.rm = TRUE)
      var_control <- var(control_data[[covariate]], na.rm = TRUE)
      smd_value_before <- smd_continuous(mean_case, mean_control, var_case, var_control)

      # SMD after weighting: Calculate weighted mean and variance for cases and controls
      n_case <- length(case_data$weights)
      n_control <- length(control_data$weights)
      weighted_mean_case <- weighted.mean(case_data[[covariate]], case_data$weights, na.rm = TRUE)
      weighted_mean_control <- weighted.mean(control_data[[covariate]], control_data$weights, na.rm = TRUE)
      weighted_var_case <- sum(case_data$weights * (case_data[[covariate]] - weighted_mean_case)^2) / (((n_case-1)/n_case)*sum(case_data$weights))
      weighted_var_control <- sum(control_data$weights * (control_data[[covariate]] - weighted_mean_control)^2) / (((n_control-1)/n_control)*sum(control_data$weights))
      print(c(weighted_mean_case, weighted_mean_control, weighted_var_case, weighted_var_control))
      print("Numerator case")
      print(sum(case_data$weights * (case_data[[covariate]] - weighted_mean_case)^2))
      print("Numerator control")
      print(sum(control_data$weights * (control_data[[covariate]] - weighted_mean_control)^2))
      smd_value_after <- smd_continuous(weighted_mean_case, weighted_mean_control, weighted_var_case, weighted_var_control)

      # Store results in data frames
      smd_before <- rbind(smd_before, data.frame(covariate = covariate, smd_value = smd_value_before))
      smd_after <- rbind(smd_after, data.frame(covariate = covariate, smd_value = smd_value_after))

    } else {
      # Categorical covariate: Calculate SMD using proportions for each level

      # Get the levels of the categorical covariate
      participant_train_data[[covariate]] <- as.factor(participant_train_data[[covariate]])
      levels_covariate <- levels(participant_train_data[[covariate]])


      # case_data <- participant_train_data %>% filter(.data[[secondary_outcome]] == "Obese")
      # control_data <- participant_train_data %>% filter(.data[[secondary_outcome]] == "Lean")

      # SMD before weighting: Calculate the proportion of each level in cases and controls
      p_case <- mean(case_data[[covariate]], na.rm = TRUE)
      p_control <- mean(control_data[[covariate]], na.rm = TRUE)
      smd_value_before <- smd_proportions(p_case, p_control)

      # SMD after weighting: Calculate weighted proportions for cases and controls
      weighted_p_case <- sum(weights_values * (case_data[[covariate]] == level), na.rm = TRUE) / sum(weights_values)
      weighted_p_control <- sum(weights_values * (control_data[[covariate]] == level), na.rm = TRUE) / sum(weights_values)
      smd_value_after <- smd_proportions(weighted_p_case, weighted_p_control)




      # Loop through each level of the categorical covariate
      # for (level in levels_covariate) {
      #   case_data <- participant_train_data %>% filter(.data[[secondary_outcome]] == "Obese")
      #   control_data <- participant_train_data %>% filter(.data[[secondary_outcome]] == "Lean")
      #
      #   # SMD before weighting: Calculate the proportion of each level in cases and controls
      #   p_case <- mean(case_data[[covariate]] == level, na.rm = TRUE)
      #   p_control <- mean(control_data[[covariate]] == level, na.rm = TRUE)
      #   smd_value_before <- smd_proportions(p_case, p_control)
      #
      #   # SMD after weighting: Calculate weighted proportions for cases and controls
      #   weighted_p_case <- sum(weights_values * (case_data[[covariate]] == level), na.rm = TRUE) / sum(weights_values)
      #   weighted_p_control <- sum(weights_values * (control_data[[covariate]] == level), na.rm = TRUE) / sum(weights_values)
      #   smd_value_after <- smd_proportions(weighted_p_case, weighted_p_control)
      #
      #
      # }
      # # Store results for each level of the categorical variable
      smd_before <- rbind(smd_before, data.frame(covariate = paste0(covariate), smd_value = smd_value_before))
      smd_after <- rbind(smd_after, data.frame(covariate = paste0(covariate), smd_value = smd_value_after))

    }
    # print("****************")
  }
  # print("****************")
  # print("smd_before")
  # print(smd_before)
  # print("****************")

  # print("****************")
  # print("smd_after")
  # print(smd_after)
  # print("****************")

  smd_before <- smd_before %>% rename(smd_value_before = smd_value)
  smd_after <- smd_after %>% rename(smd_value_after = smd_value)


  # Return the SMD values before and after applying weights
  return(list(smd_before = smd_before, smd_after = smd_after))
}
