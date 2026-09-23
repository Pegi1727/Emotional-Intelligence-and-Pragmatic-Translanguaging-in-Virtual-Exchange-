# ==============================================================================
# Script 04: Linear Regression & Predictive Modeling (OLS)
# Project: Emotional Intelligence & Pragmatic Translanguaging (N = 100)
# Journal: Journal of Research in Applied Linguistics (RALs)
# Author: Pegah Merrikhi
# ==============================================================================

library(tidyverse)
library(car)

data_file <- ifelse(file.exists("data/dataset_clean_processed.csv"),
                    "data/dataset_clean_processed.csv", "dataset_full.csv")
df <- read_csv(data_file, show_col_types = FALSE)

cat("========================================================\n")
cat("Model 1: Predicting Translanguaging Index (TI) from Trait EI\n")
cat("========================================================\n")

m1 <- lm(TI ~ EQ_Score, data = df)
summary_m1 <- summary(m1)
print(summary_m1)

cat(sprintf("Model 1 Summary: R^2 = %.4f, Adjusted R^2 = %.4f, F(1, 98) = %.2f, p = %.3e\n",
            summary_m1$r.squared, summary_m1$adj.r.squared,
            summary_m1$fstatistic[1], pf(summary_m1$fstatistic[1], 1, 98, lower.tail = FALSE)))

cat("\n========================================================\n")
cat("Model 2: Predicting Relational Solidarity (C2) from Trait EI\n")
cat("========================================================\n")

m2 <- lm(C2 ~ EQ_Score, data = df)
summary_m2 <- summary(m2)
print(summary_m2)

cat(sprintf("Model 2 Summary: R^2 = %.4f, Adjusted R^2 = %.4f, F(1, 98) = %.2f, p = %.3e\n",
            summary_m2$r.squared, summary_m2$adj.r.squared,
            summary_m2$fstatistic[1], pf(summary_m2$fstatistic[1], 1, 98, lower.tail = FALSE)))

cat("\n========================================================\n")
cat("Model 3: Multiple Regression for Functional Subtypes (C1 - C5)\n")
cat("========================================================\n")

models <- list(
  "Clarification (C1)" = lm(C1 ~ EQ_Score, data = df),
  "Accommodation (C3)" = lm(C3 ~ EQ_Score, data = df),
  "Last-Language (C4)" = lm(C4 ~ EQ_Score, data = df),
  "Sequential (C5)" = lm(C5 ~ EQ_Score, data = df)
)

for(name in names(models)) {
  m <- models[[name]]
  s <- summary(m)
  beta <- coef(s)["EQ_Score", "Estimate"]
  se <- coef(s)["EQ_Score", "Std. Error"]
  t_val <- coef(s)["EQ_Score", "t value"]
  p_val <- coef(s)["EQ_Score", "Pr(>|t|)"]
  r2 <- s$r.squared
  cat(sprintf("%-25s | Beta = %7.3f (SE = %5.3f) | t = %6.2f | p = %.4f | R^2 = %.3f\n",
              name, beta, se, t_val, p_val, r2))
}

cat("\n[SUCCESS] Regression models estimated and formatted.\n")
