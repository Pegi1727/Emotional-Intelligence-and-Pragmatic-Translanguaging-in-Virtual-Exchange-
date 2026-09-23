# ==============================================================================
# Reproducible Statistical Pipeline (R Version)
# Study: Trait Emotional Intelligence and Translanguaging in Virtual Exchange (N = 100)
# ==============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(car)
  library(multcomp)
})

# Load dataset
data_path <- "../data/dataset_full.csv"
df <- read.csv(data_path)

# Descriptives
cat("=== DESCRIPTIVE STATISTICS ===\n")
df %>%
  select(EQ, Turns, TT, TI, RelSol, C1, C2, C3, C4, C5) %>%
  summary()

# Correlation Matrix
cat("\n=== BIVARIATE CORRELATIONS ===\n")
cor_matrix <- cor(df[, c("EQ", "Turns", "TT", "TI", "RelSol", "C1", "C2", "C3", "C4", "C5")],
                  use = "complete.obs")
print(round(cor_matrix, 3))

# Linear Regressions
cat("\n=== REGRESSION: TI ~ EQ ===\n")
fit_ti <- lm(TI ~ EQ, data = df)
summary(fit_ti)

cat("\n=== REGRESSION: RelSol ~ EQ ===\n")
fit_relsol <- lm(RelSol ~ EQ, data = df)
summary(fit_relsol)

# ANOVA & Post-hoc
if ("EQ_group" %in% colnames(df)) {
  cat("\n=== ANOVA ACROSS EQ GROUPS ===\n")
  aov_ti <- aov(TI ~ EQ_group, data = df)
  print(summary(aov_ti))
  print(TukeyHSD(aov_ti))

  aov_rel <- aov(RelSol ~ EQ_group, data = df)
  print(summary(aov_rel))
  print(TukeyHSD(aov_rel))
}
