#' To perform logistic regression
#' with weights generated from raking method
#'
#' @param data The participant data consisting of all the charectersitics of all the participants.
#' @param population_margins A list of data.frames with population distributions
#' @param outcome The dependent variable for logistic regression
#' @param predictors A vector of predictor variable names
#'
#' @return A list consisting of weights and model summary.
#' @export
#'
#' @examples
#' # Participant data (primary demographics and outcomes)
#' set.seed(123)  # For reproducibility
#'
#' # Simulate participant data
#' participant_data <- data.frame(
#'   ParticipantID = 1:500,
#'   age = sample(c("18-30", "31-50", "51+"), 500, replace = TRUE),
#'   sex = sample(c("Male", "Female"), 500, replace = TRUE),
#'   BMIzscore = rnorm(500, mean = 0, sd = 1)  # Normally distributed BMI z-scores
#' )
#'
#' # Simulate obesity status based on BMI z-score
#' # Using a threshold: obesity is more likely with higher BMI z-scores
#' participant_data$obese <- ifelse(participant_data$BMIzscore > 1, 1, 0)  # Obese if BMI z-score > 1
#'
#' # Simulate NAFLD status, influenced by obesity
#' # Higher probability of NAFLD in obese participants
#' participant_data$nafld <- ifelse(participant_data$obese == 1,
#'                                  rbinom(n = 500, size = 1, prob = 0.7),  # 70% chance if obese
#'                                  rbinom(n = 500, size = 1, prob = 0.3))  # 30% chance if not obese
#'
#' # Metabolite data (metabolite concentrations for participants)
#' metabolite_data <- data.frame(
#'   ParticipantID = sample(1:500, 500, replace = TRUE),
#'   Metabolite1 = rnorm(500, mean = 5, sd = 1.5),
#'   Metabolite2 = rnorm(500, mean = 3, sd = 1),
#'   Metabolite3 = rnorm(500, mean = 7, sd = 2)
#' )
#'
#' # Merge participant data and metabolite data
#' combined_data <- merge(participant_data, metabolite_data, by = "ParticipantID")
#'
#' population_margins <- list(
#'   age = data.frame(age = c("18-30", "31-50", "51+"),
#'                    Freq = c(0.3, 0.4, 0.3)),
#'   sex = data.frame(sex = c("Male", "Female"),
#'                    Freq = c(0.5, 0.5)),
#'   nafld = data.frame(nafld = c(0, 1),
#'                      Freq = c(0.7, 0.3))  # Reflects original study design
#' )
#'
#'
#'
#' # Perform raking and logistic regression
#' result <- perform_raking_and_logistic_regression(
#'   data = combined_data,
#'   population_margins = population_margins,
#'   outcome = "obese",                   # Secondary outcome
#'   predictors = c("age", "sex", "BMIzscore")  # Predictors
#' )
#'
#' # Display weights and model summary
#' print("Weights:")
#' print(head(result$weights))
#'
#' print("Logistic Regression Model Summary:")
#' print(result$model_summary)
perform_raking_and_logistic_regression <- function(data,train_data, population_margins, outcome, predictors) {
  # Arguments:
  # data: The participant dataset
  # population_margins: A list of data.frames with population distributions
  # outcome: The dependent variable for logistic regression
  # predictors: A vector of predictor variable names
  #

  # Ensure required columns exist in the dataset
  required_columns <- c(names(population_margins), outcome, predictors)
  # print(setdiff(required_columns,colnames(data)))
  # print(required_columns)
  print(population_margins)
  if (!all(required_columns %in% colnames(data))) {
    stop("Some required columns are missing in the dataset.")
  }

  # Convert categorical variables to factors
  for (var in names(population_margins)) {
    data[[var]] <- as.factor(data[[var]])
  }

  data[[outcome]] <- as.integer(as.factor(data[[outcome]])) - 1

  # Create survey design object
  design <- svydesign(ids = ~1, data = data, weights = ~1)

  # Perform raking
  rake_design <- rake(
    design = design,
    sample.margins = lapply(names(population_margins), function(var) as.formula(paste("~", var))),
    population.margins = population_margins
  )

  # Extract weights from raked design
  data$weights <- weights(rake_design)
  train_data_weights <- data[intersect(rownames(train_data),rownames(data)),]
  print(outcome)
  # Logistic regression using raked weights
  formula <- as.formula(paste(outcome, "~", paste(predictors, collapse = " + ")))
  print(formula)
  weighted_model <- svyglm(formula, design = rake_design, family = quasibinomial())
  print("105")
  weights_with_subjid <- data.frame(list(subjid = rownames(data),
                              weights = data$weights))
  # Return results
  return(list(
    weights = data$weights,
    model_summary = summary(weighted_model),
    train_weights = train_data_weights$weights,
    weights_with_subjid = weights_with_subjid
  ))
}
