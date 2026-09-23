# ==============================================================================
# Script 01: Data Import, Screening, Validation, and Preprocessing
# Project: Emotional Intelligence & Pragmatic Translanguaging (N = 100)
# Journal: Journal of Research in Applied Linguistics (RALs)
# Author: Pegah Merrikhi
# ==============================================================================

# Install required packages if missing
required_pkgs <- c("tidyverse", "psych", "readr", "knitr")
new_pkgs <- required_pkgs[!(required_pkgs %in% installed.packages()[,"Package"])]
if(length(new_pkgs)) install.packages(new_pkgs, repos = "http://cran.us.r-project.org")

library(tidyverse)
library(psych)
library(readr)

cat("========================================================\n")
cat("Step 1: Loading Dataset...\n")
cat("========================================================\n")

# Load raw full dataset
data_file <- "data/dataset_full.csv"
if(!file.exists(data_file)) {
  data_file <- "dataset_full.csv"
}

df <- read_csv(data_file, show_col_types = FALSE)
cat(sprintf("Loaded dataset with %d rows and %d variables.\n", nrow(df), ncol(df)))

# Verify participant cohort size
stopifnot("Cohort size must be exactly 100" = nrow(df) == 100)

cat("\n========================================================\n")
cat("Step 2: Trait EI Stratification (Tertile Cut-points)\n")
cat("========================================================\n")

# Classify participants into three trait EI groups based on established cutoffs:
# Low EI: <= 89 | Medium EI: 90 - 119 | High EI: >= 120
df <- df %>%
  mutate(
    EI_Group = case_when(
      EQ_Score <= 89 ~ "Low EI",
      EQ_Score >= 90 & EQ_Score <= 119 ~ "Medium EI",
      EQ_Score >= 120 ~ "High EI",
      TRUE ~ NA_character_
    ),
    EI_Group = factor(EI_Group, levels = c("Low EI", "Medium EI", "High EI"))
  )

group_summary <- df %>%
  group_by(EI_Group) %>%
  summarise(
    n = n(),
    Mean_EI = mean(EQ_Score, na.rm = TRUE),
    SD_EI = sd(EQ_Score, na.rm = TRUE),
    Min_EI = min(EQ_Score, na.rm = TRUE),
    Max_EI = max(EQ_Score, na.rm = TRUE),
    .groups = "drop"
  )

print(group_summary)

cat("\n========================================================\n")
cat("Step 3: Screening for Missing Values and Univariate Outliers\n")
cat("========================================================\n")

missing_counts <- colSums(is.na(df))
cat("Missing value tally per column:\n")
print(missing_counts)

# Calculate Z-scores for focal variables
focal_vars <- c("EQ_Score", "Total_Turns", "Total_TT", "TI", "C1", "C2", "C3", "C4", "C5")
existing_focal <- intersect(focal_vars, names(df))

outliers <- df %>%
  select(all_of(existing_focal)) %>%
  scale() %>%
  as_tibble() %>%
  summarise(across(everything(), ~ sum(abs(.) > 3.29, na.rm = TRUE)))

cat("\nUnivariate Outliers (|Z| > 3.29):\n")
print(outliers)

# Save processed clean datasets
if(!dir.exists("data")) dir.create("data", recursive = TRUE)
write_csv(df, "data/dataset_clean_processed.csv")
cat("\n[SUCCESS] Clean dataset saved to 'data/dataset_clean_processed.csv'\n")
