file_path_participant <- "../../related_material/dataset/obesity/ST002269_data_metadata.csv"
file_path_metabolite <- "../../related_material/dataset/obesity/ST002269_data_mets.csv"

file_ext <- "csv"

participant_data <- read_file(file_path = file_path_participant,
                              file_ext = file_ext)
metabolite_data <- read_file(file_path = file_path_metabolite,
                            file_ext = file_ext)


processed_data <- pre_process(participant_data = participant_data,
                       metabolite_data = metabolite_data,
                       metabolite_ids_are_rows = FALSE,
                       case_control_col="nafld")

participant_data_out <- processed_data$participant_data
metabolite_data_out <- processed_data$metabolite_data
combined_data <- processed_data$combined_data
train_data <- processed_data$train
test_data <- processed_data$test

primary_outcome <- "nafld"
ip_weights <- get_weights(train_data, primary_outcome)

alpha <- 0.5
cv_iter <- 5
secondary_outcome <- "obese"

x <- model.matrix(as.formula(paste(secondary_outcome, "~ . - 1")), data = train_data)  # Create model matrix (no intercept)
y <- as.factor(train_data[[secondary_outcome]])  # Outcome variable (factor)


cv_fit <- cv.glmnet(x, y, family = "binomial", alpha = alpha, weights = ip_weights$values, nfolds = cv_iter)
