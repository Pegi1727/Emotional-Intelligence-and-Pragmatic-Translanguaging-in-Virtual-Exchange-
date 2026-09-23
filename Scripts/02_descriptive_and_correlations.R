# ==============================================================================
# Script 02: Comprehensive Descriptive Statistics & Correlation Matrix
# Project: Emotional Intelligence & Pragmatic Translanguaging (N = 100)
# Journal: Journal of Research in Applied Linguistics (RALs)
# Author: Pegah Merrikhi
# ==============================================================================

library(tidyverse)
library(psych)
library(knitr)

data_file <- ifelse(file.exists("data/dataset_clean_processed.csv"),
                    "data/dataset_clean_processed.csv", "dataset_full.csv")
df <- read_csv(data_file, show_col_types = FALSE)

cat("========================================================\n")
cat("Table 1: Descriptive Statistics for Overall Cohort (N = 100)\n")
cat("========================================================\n")

key_vars <- c("EQ_Score", "Total_Turns", "Total_TT", "TI", "C1", "C2", "C3", "C4", "C5")
available_vars <- intersect(key_vars, names(df))

desc_stats <- describe(df[, available_vars]) %>%
  as.data.frame() %>%
  rownames_to_column(var = "Variable") %>%
  select(Variable, n, mean, sd, median, min, max, skew, kurtosis)

print(desc_stats, digits = 3)
write_csv(desc_stats, "data/table1_descriptive_stats_output.csv")

cat("\n========================================================\n")
cat("Table 2: Descriptive Statistics Stratified by EI Group\n")
cat("========================================================\n")

if("EI_Group" %in% names(df)) {
  desc_by_group <- df %>%
    group_by(EI_Group) %>%
    summarise(
      N = n(),
      Mean_EQ = mean(EQ_Score), SD_EQ = sd(EQ_Score),
      Mean_TI = mean(TI), SD_TI = sd(TI),
      Mean_C1 = mean(C1), SD_C1 = sd(C1),
      Mean_C2 = mean(C2), SD_C2 = sd(C2),
      Mean_C3 = mean(C3), SD_C3 = sd(C3),
      Mean_C4 = mean(C4), SD_C4 = sd(C4),
      Mean_C5 = mean(C5), SD_C5 = sd(C5),
      .groups = "drop"
    )
  print(desc_by_group, digits = 3)
  write_csv(desc_by_group, "data/table2_descriptives_by_group.csv")
}

cat("\n========================================================\n")
cat("Correlation Matrix: Pearson r & Significance Levels\n")
cat("========================================================\n")

corr_analysis <- corr.test(df[, available_vars], method = "pearson", adjust = "none")

cat("\n--- Pearson Correlation Coefficients (r) ---\n")
print(round(corr_analysis$r, 3))

cat("\n--- p-values ---\n")
print(round(corr_analysis$p, 4))

write.csv(round(corr_analysis$r, 4), "data/correlation_matrix_r.csv")
write.csv(round(corr_analysis$p, 4), "data/correlation_matrix_pvalues.csv")
cat("\n[SUCCESS] Descriptive statistics and correlation outputs successfully exported.\n")
