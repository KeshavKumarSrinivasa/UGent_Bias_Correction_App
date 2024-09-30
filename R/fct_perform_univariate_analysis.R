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
perform_univariate_analysis <- function(input_data, secondary_outcome) {

  df <- input_data$merged_data

  # Remove 'subjid' column (subject IDs), and any non-numeric columns if needed
  df <- df %>% select(-subjid)

  # Response variable
  response_var <- secondary_outcome

  # Initialize an empty list to store results (more efficient than rbind in loops)
  results_list <- list()

  # Vector to store p-values for FDR adjustment
  p_values <- numeric()

  # Loop through each predictor variable
  for (col in colnames(df)) {
    if (col != response_var) {
      # Fit univariate logistic regression model
      formula <- as.formula(paste(response_var, "~", col))
      model <- glm(formula, data = df, family = binomial)
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
        FDR = NA,  # Placeholder for FDR values
        stringsAsFactors = FALSE
      )

      # Collect p-values for FDR adjustment
      p_values <- c(p_values, p_value)
    }
  }

  # Convert list of results into a data frame
  results <- do.call(rbind, results_list)

  # Adjust p-values for False Discovery Rate (FDR)
  fdr_values <- p.adjust(p_values, method = "fdr")
  results$FDR <- fdr_values

  # Calculate -log10(FDR)
  results$logFDR <- -log10(results$FDR)

  # Step 1: Create Volcano Plot
  volcano_plot <- ggplot(results, aes(x = Estimate, y = logFDR)) +
    geom_point(aes(color = FDR < 0.05)) +  # Color points based on significance
    scale_color_manual(values = c("grey", "red")) +  # Red for significant, black for non-significant
    labs(title = "Volcano Plot", x = "Effect Size (Estimate)", y = "-log10(FDR)") +
    theme_minimal() +
    theme(legend.position = "none")

  # Step 2: Return results and volcano plot
  return(list(
    results = results,
    volcano_plot = volcano_plot
  ))
}
