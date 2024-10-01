file_path_participant <- "../../related_material/dataset/obesity/ST002269_data_metadata.csv"
file_path_metabolite <- "../../related_material/dataset/obesity/ST002269_data_mets.csv"

file_ext <- "csv"

participant_data <- read_file(file_path = file_path_participant, file_ext = file_ext)
metabolite_data <- read_file(file_path = file_path_metabolite, file_ext = file_ext)


processed_data <- pre_process(
  participant_data = participant_data,
  metabolite_data = metabolite_data,
  metabolite_ids_are_rows = FALSE,
  case_control_col = "nafld"
)


participant_data_out <- processed_data$participant_data
metabolite_data_out <- processed_data$metabolite_data
combined_data <- processed_data$combined_data
train_data <- processed_data$train
test_data <- processed_data$test
#
# primary_outcome <- "nafld"
# alpha <- 0.5
# cv_iter <- 5
# secondary_outcome <- "obese"
#
#
# ip_weights <- get_weights(train_data, primary_outcome)
#
# #
# # rownames(train_data) <- train_data[["subjid"]]
# # train_data <- train_data[,-c(which(colnames(train_data)=="subjid"))]
# #
# # x <- model.matrix(as.formula(paste(secondary_outcome, "~ . - 1")), data = train_data)  # Create model matrix (no intercept)
# # y <- as.factor(train_data[[secondary_outcome]])  # Outcome variable (factor)
# #
# #
# # cv_fit <- cv.glmnet(x, y, family = "binomial", alpha = alpha, weights = ip_weights$weight_values, nfolds = cv_iter)
# #
# #
# # # Step 1: Extract the coefficients at the best lambda
# # coef_matrix <- coef(cv_fit, s = "lambda.min")
# # coef_df <- as.data.frame(as.matrix(coef_matrix))
# # coef_df$feature <- rownames(coef_df)
# # colnames(coef_df)[1] <- "coefficient"
# # coef_df <- coef_df %>% filter(feature != "(Intercept)")  # Remove intercept
# #
# # # Step 2: Get the top 10 coefficients by absolute value (excluding intercept)
# # top_ten_coef <- coef_df %>%
# #   arrange(desc(abs(coefficient))) %>%
# #   head(10)
# #
# #
# # rownames(test_data) <- test_data[["subjid"]]
# # test_data <- test_data[,-c(which(colnames(test_data)=="subjid"))]
# #
# #
# # # Step 3: Calculate AUC-ROC on the test data
# # test_x <- model.matrix(as.formula(paste(secondary_outcome, "~ . - 1")), data = test_data)  # Create model matrix (no intercept)
# # test_y <- as.factor(test_data[[secondary_outcome]])  # Outcome variable (factor)
# # y_pred <- predict(cv_fit,
# #                   newx = test_x,
# #                   s = "lambda.min",
# #                   type = "response")
# #
# # y_pred <- as.vector(y_pred)
# #
# # roc_obj <- roc(test_y, y_pred)  # Calculate ROC curve
# #
# # # Step 4: Calculate the AUC value and 95% confidence interval for AUC
# #
# # auc_value <- ci.auc(roc_obj)[2] # AUC value
# # auc_ci <- ci(roc_obj)[c(1,3)] # 95% Confidence interval
# #
# #
# # # Calculate confidence intervals for the ROC curve at specific sensitivity levels
# # ci <- ci.se(roc_obj, specificities = seq(0, 1, 0.01))
# #
# # # Convert the confidence interval object to a dataframe
# # ci_df <- data.frame(
# #   x = as.numeric(rownames(ci)),
# #   ymin = ci[, 1],
# #   ymax = ci[, 3]
# # )
# #
# # # Create the ROC plot with confidence bands
# # roc_plot <- ggroc(roc_obj, color = "blue") +
# #   geom_ribbon(data = ci_df, aes(x = x, ymin = ymin, ymax = ymax), fill = "blue", alpha = 0.2) +  # Add confidence bands
# #   ggtitle(paste("ROC Curve (AUC = ", round(auc_value, 3), ")", sep = "")) +
# #   theme_minimal() +
# #   annotate(
# #     "text",
# #     x = 0.8,
# #     y = 0.2,
# #     label = paste0("AUC 95% CI: (", round(auc_ci[1], 3), ", ", round(auc_ci[2], 3), ")"),
# #     size = 5,
# #     hjust = 0
# #   )
# #
# # roc_plot
#
#
# # Step 1: Pre-process the data
# message("Step 1: Pre-processing the data")
# processed_data <- pre_process(
#   participant_data,
#   metabolite_data,
#   metabolite_ids_are_rows = FALSE,
#   case_control_col = "nafld",
#   split_ratio = 0.8
# )
#
# participant_data_out <- processed_data$participant_data
# metabolite_data_out <- processed_data$metabolite_data
# combined_data <- processed_data$combined_data
# train_data <- processed_data$train
# test_data <- processed_data$test
#
# # Step 2: Get Weights
# message("Step 2: Getting weights")
# ip_weights <- get_weights(train_data, primary_outcome)
#
# # Step 3: Multivariate analysis
# message("Step 3: Performing multivariate analysis")
# multivariate_results <- perform_multivariate_analysis(
#   train_data = train_data,
#   test_data = test_data,
#   secondary_outcome = secondary_outcome,
#   alpha = alpha,
#   cv_iter = cv_iter,
#   weights = ip_weights$weight_values
# )
#
# # Step 4: Univariate analysis
# message("Step 4: Performing univariate analysis")
# univariate_results <- perform_univariate_analysis(train_data, metabolite_data_out, secondary_outcome)
#
# # # Step 5: Standardized mean difference analysis
# message("Step 5: Calculating standardized mean difference")
# smd_results <- calculate_smd_all_covariates(
#   participant_data,
#   train_data_with_weights = ip_weights$train_data_with_weights,
#   primary_outcome,
#   secondary_outcome,
#   covariates = covariates
# )
