# ==============================================================================
# Script 05: Publication-Ready Visualizations (Figures 1-4 & High-Res Export)
# Project: Emotional Intelligence & Pragmatic Translanguaging (N = 100)
# Journal: Journal of Research in Applied Linguistics (RALs)
# Author: Pegah Merrikhi
# ==============================================================================

library(tidyverse)
library(corrplot)
library(cowplot)
library(gridExtra)

# Create figures directory
if(!dir.exists("figures_r")) dir.create("figures_r", recursive = TRUE)

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

# Figure 1: Correlation Matrix Heatmap
cat("Rendering Figure 1: Correlation Matrix...\n")
key_vars <- c("EQ_Score", "Total_Turns", "Total_TT", "TI", "C1", "C2", "C3", "C4", "C5")
cor_mat <- cor(df[, key_vars], use = "complete.obs")

png("figures_r/figure1_correlation_matrix_R.png", width = 2400, height = 2200, res = 300)
corrplot(cor_mat, method = "color", type = "upper",
         addCoef.col = "black", number.cex = 0.8,
         tl.col = "black", tl.srt = 45,
         col = colorRampPalette(c("#E11D48", "#FFFFFF", "#0D9488"))(200),
         title = "\nFigure 1: Pearson Correlation Heatmap of Focal Variables",
         mar = c(0,0,2,0))
dev.off()

# Figure 2: Linear Regression Slopes (TI and C2)
cat("Rendering Figure 2: Regression Slopes...\n")
p_reg1 <- ggplot(df, aes(x = EQ_Score, y = TI)) +
  geom_point(color = "#0284C7", alpha = 0.65, size = 2.5) +
  geom_smooth(method = "lm", color = "#0369A1", fill = "#BAE6FD", linewidth = 1.2) +
  annotate("text", x = 70, y = max(df$TI) * 0.95,
           label = "r = .509, R² = .259, p < .001",
           hjust = 0, size = 3.8, fontface = "bold", color = "#0369A1") +
  labs(x = "Trait Emotional Intelligence (EQ Score)",
       y = "Translanguaging Index (TI %)",
       title = "A: Trait EI predicting Translanguaging Index") +
  theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 12))

p_reg2 <- ggplot(df, aes(x = EQ_Score, y = C2)) +
  geom_point(color = "#10B981", alpha = 0.65, size = 2.5) +
  geom_smooth(method = "lm", color = "#059669", fill = "#A7F3D0", linewidth = 1.2) +
  annotate("text", x = 70, y = max(df$C2) * 0.95,
           label = "r = .954, R² = .834, p < .001",
           hjust = 0, size = 3.8, fontface = "bold", color = "#059669") +
  labs(x = "Trait Emotional Intelligence (EQ Score)",
       y = "Relational Solidarity Turns (C2)",
       title = "B: Trait EI predicting Relational Solidarity") +
  theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 12))

fig2_combined <- plot_grid(p_reg1, p_reg2, ncol = 2)
ggsave("figures_r/figure2_regression_models_R.png", fig2_combined, width = 12, height = 5.5, dpi = 300)

# Figure 3: Group Comparisons (Boxplots + Jitter)
cat("Rendering Figure 3: Group Comparisons Across EI Tertiles...\n")
palette_groups <- c("Low EI" = "#FF6B6B", "Medium EI" = "#F59E0B", "High EI" = "#10B981")

p_box1 <- ggplot(df, aes(x = EI_Group, y = TI, fill = EI_Group)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA, width = 0.5) +
  geom_jitter(width = 0.18, alpha = 0.5, size = 1.8) +
  scale_fill_manual(values = palette_groups) +
  labs(x = "Trait EI Cohort", y = "Translanguaging Index (TI %)", title = "Translanguaging Index") +
  theme_minimal(base_size = 11) +
  theme(legend.position = "none", panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 11))

p_box2 <- ggplot(df, aes(x = EI_Group, y = C2, fill = EI_Group)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA, width = 0.5) +
  geom_jitter(width = 0.18, alpha = 0.5, size = 1.8) +
  scale_fill_manual(values = palette_groups) +
  labs(x = "Trait EI Cohort", y = "Relational Solidarity (C2)", title = "Relational Solidarity") +
  theme_minimal(base_size = 11) +
  theme(legend.position = "none", panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 11))

p_box3 <- ggplot(df, aes(x = EI_Group, y = C4, fill = EI_Group)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA, width = 0.5) +
  geom_jitter(width = 0.18, alpha = 0.5, size = 1.8) +
  scale_fill_manual(values = palette_groups) +
  labs(x = "Trait EI Cohort", y = "Last-Language Use (C4)", title = "Last-Language Persistence") +
  theme_minimal(base_size = 11) +
  theme(legend.position = "none", panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 11))

fig3_combined <- plot_grid(p_box1, p_box2, p_box3, ncol = 3)
ggsave("figures_r/figure3_group_comparisons_R.png", fig3_combined, width = 14, height = 5, dpi = 300)

# Figure 4: Pragmatic Distribution Shift
cat("Rendering Figure 4: Pragmatic Distribution Shift...\n")
pragmatic_summary <- df %>%
  group_by(EI_Group) %>%
  summarise(
    Clarification = mean(C1),
    Solidarity = mean(C2),
    Accommodation = mean(C3),
    Last_Language = mean(C4),
    Sequential = mean(C5),
    .groups = "drop"
  ) %>%
  pivot_longer(cols = -EI_Group, names_to = "Pragmatic_Function", values_to = "Mean_Count")

p_bar <- ggplot(pragmatic_summary, aes(x = EI_Group, y = Mean_Count, fill = Pragmatic_Function)) +
  geom_bar(stat = "identity", position = "stack", width = 0.6) +
  scale_fill_brewer(palette = "Set2") +
  labs(x = "Trait EI Cohort", y = "Mean Utterance Frequency",
       fill = "Pragmatic Function",
       title = "Figure 4: Functional Distribution Shift Across Trait EI Tiers") +
  theme_minimal(base_size = 12) +
  theme(legend.position = "right", panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 13))

ggsave("figures_r/figure4_pragmatic_distribution_R.png", p_bar, width = 9, height = 5.5, dpi = 300)

cat("\n[SUCCESS] All 4 publication-quality figures successfully rendered via R.\n")
