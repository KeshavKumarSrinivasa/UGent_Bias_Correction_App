#' perform_univariate_analysis
#'
#' @description Performs univariate logistic regression for each predictor variable against the response (secondary outcome).
#'
#' @return A data frame with estimates, standard errors, p-values, FDR, and log10(FDR) for each predictor.
#'
#' @noRd
# Load necessary libraries
library(ggplot2)
library(dplyr)

# Univariate analysis function that returns results and volcano plot
perform_univariate_analysis <- function(train_data,
                                        metabolite_data,
                                        secondary_outcome,
                                        weights_values) {
  # Get vector of metabolites
  metabolites <- metabolite_data %>% select(-c("subjid")) %>% colnames()

  # Replacing " ", "+" with "_"
  renamed_metabolites <- gsub(" ","_",metabolites)
  renamed_metabolites <- gsub("\\+","_",renamed_metabolites)
  renamed_metabolites <- gsub("\\-","_",renamed_metabolites)
  renamed_metabolites <- gsub("\\(","_",renamed_metabolites)
  renamed_metabolites <- gsub("\\)","_",renamed_metabolites)
  renamed_metabolites <- gsub("\\:","_",renamed_metabolites)


  # Take only columns of interest. That is, secondary outcome and metabolites
  data_for_univariate_analysis <- train_data %>% select(one_of(c(secondary_outcome, metabolites))) %>%   mutate(across(one_of(secondary_outcome), as.factor))

  #Renaming the column names
  colnames(data_for_univariate_analysis) <- c(secondary_outcome,renamed_metabolites)

  # Response variable
  response_var <- secondary_outcome

  # Initialize an empty list to store results (more efficient than rbind in loops)
  results_list <- list()

  # Vector to store p-values for FDR adjustment
  p_values <- numeric()
  print("hello")
  not_working <- c()
  print(length(colnames(data_for_univariate_analysis)))
  # Loop through each predictor variable
  for (col in colnames(data_for_univariate_analysis)) {
    tryCatch({
    if (col != response_var) {
      # Fit univariate logistic regression model
      formula <- as.formula(paste(response_var, "~", col))
      # weights_values <- abs(rnorm(length(data_for_univariate_analysis[[response_var]])))
      model <- glm(formula, data = data_for_univariate_analysis, family = binomial,weights = weights_values)
      summary_model <- summary(model)

      # Extract estimate, standard error, and p-value for the predictor
      estimate <- summary_model$coefficients[2, "Estimate"]
      std_error <- summary_model$coefficients[2, "Std. Error"]
      p_value <- summary_model$coefficients[2, "Pr(>|z|)"]

      # Store result in the list
      results_list[[col]] <- data.frame(
        Predictor = col,
        Estimate = estimate,
        StdError = std_error,
        PValue = p_value,
        FDR = NA,
        # Placeholder for FDR values
        stringsAsFactors = FALSE
      )

      # Collect p-values for FDR adjustment
      p_values <- c(p_values, p_value)
    }
    },error = function(e) {
    print(e)
    not_working <- append(not_working,e)})}

  print("finished loop")
  print(length(not_working))

  # Convert list of results into a data frame
  results <- do.call(rbind, results_list)

  print("finished do.call")


  # Adjust p-values for False Discovery Rate (FDR)
  fdr_values <- p.adjust(p_values, method = "fdr")
  results$FDR <- fdr_values

  print("finished Adjust p-values")

  # Calculate -log10(FDR)
  results$logFDR <- -log10(results$FDR)

  print("finished log10 p-values")

  print(results)
  print(class(results))
  # Step 1: Create Volcano Plot
  volcano_plot <- ggplot(results, aes(x = Estimate, y = logFDR)) +
    geom_point(aes(color = FDR < 0.05)) +  # Color points based on significance
    scale_color_manual(values = c("grey", "red")) +  # Red for significant, grey for non-significant
    labs(title = "Volcano Plot", x = "Effect Size (Estimate)", y = "-log10(FDR)") +
    theme_minimal() +
    theme(legend.position = "none")

  # write.csv(results,"univariate_analysis.csv")
  print("finished volcano_plot")

  # Step 2: Return results and volcano plot
  return(list(results = results, volcano_plot = volcano_plot))
}
