# ==============================================================================
# Script 03: Inferential Statistics — One-Way ANOVA and Tukey HSD Post-Hoc Tests
# Project: Emotional Intelligence & Pragmatic Translanguaging (N = 100)
# Journal: Journal of Research in Applied Linguistics (RALs)
# Author: Pegah Merrikhi
# ==============================================================================

library(tidyverse)
library(car)
library(rstatix)

data_file <- ifelse(file.exists("data/dataset_clean_processed.csv"),
                    "data/dataset_clean_processed.csv", "dataset_full.csv")
df <- read_csv(data_file, show_col_types = FALSE)

if(!"EI_Group" %in% names(df)) {
  df <- df %>%
    mutate(
      EI_Group = case_when(
        EQ_Score <= 89 ~ "Low EI",
        EQ_Score >= 90 & EQ_Score <= 119 ~ "Medium EI",
        EQ_Score >= 120 ~ "High EI"
      ),
      EI_Group = factor(EI_Group, levels = c("Low EI", "Medium EI", "High EI"))
    )
}

dep_vars <- c("TI", "C1", "C2", "C3", "C4", "C5")
available_deps <- intersect(dep_vars, names(df))

cat("========================================================\n")
cat("One-Way ANOVA Across Trait EI Groups (Low vs Medium vs High)\n")
cat("========================================================\n\n")

for(v in available_deps) {
  cat(paste0(">>> Dependent Variable: ", v, "\n"))
  formula_v <- as.formula(paste(v, "~ EI_Group"))

  # Levene's Test for Homogeneity of Variance
  levene <- leveneTest(formula_v, data = df)
  cat(sprintf("   Levene's Test: F(2, 97) = %.3f, p = %.4f\n", leven$`F value`[1], leven$`Pr(>F)`[1]))

  # One-Way ANOVA model
  aov_model <- aov(formula_v, data = df)
  aov_summary <- summary(aov_model)
  print(aov_summary)

  # Effect Size: Eta-Squared (eta2)
  ss_effect <- aov_summary[[1]]["EI_Group", "Sum Sq"]
  ss_total <- sum(aov_summary[[1]][, "Sum Sq"])
  eta_sq <- ss_effect / ss_total
  cat(sprintf("   Effect Size (eta-squared): %.3f\n", eta_sq))

  # Tukey HSD Post-Hoc Pairwise Comparisons
  cat("   Tukey HSD Post-Hoc Comparisons:\n")
  tukey <- TukeyHSD(aov_model)
  print(round(tukey$EI_Group, 4))
  cat("--------------------------------------------------------\n\n")
}

cat("[SUCCESS] ANOVA and Post-Hoc computations completed successfully.\n")
