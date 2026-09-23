# ==============================================================================
# 07_publication_visualizations.py
# Generate Figures 1-4 (Heatmaps, Regressions, Boxplots, Bar Charts) at 300 DPI
# Author: Pegah Merrikhi
# ==============================================================================
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

os.makedirs("figures_python", exist_ok=True)
data_path = "data/dataset_clean_processed.csv" if os.path.exists("data/dataset_clean_processed.csv") else "dataset_full.csv"
df = pd.read_csv(data_path)

if 'EI_Group' not in df.columns:
    df['EI_Group'] = df['EQ_Score'].apply(lambda s: "Low EI" if s<=89 else ("Medium EI" if s<=119 else "High EI"))

sns.set_theme(style="whitegrid")

# Fig 1: Heatmap
cols = ["EQ_Score", "Total_Turns", "Total_TT", "TI", "C1", "C2", "C3", "C4", "C5"]
plt.figure(figsize=(9, 7))
sns.heatmap(df[cols].corr(), annot=True, fmt=".2f", cmap="vlag", vmin=-1, vmax=1)
plt.title("Figure 1: Pearson Correlation Heatmap", fontweight='bold', fontsize=12)
plt.tight_layout()
plt.savefig("figures_python/figure1_correlation_matrix.png", dpi=300)
plt.close()

# Fig 2: Regressions
fig, axes = plt.subplots(1, 2, figsize=(13, 5))
sns.regplot(data=df, x="EQ_Score", y="TI", ax=axes[0], color="#0284C7")
axes[0].set_title("A: Trait EI predicting Translanguaging Index (TI)", fontweight='bold')
sns.regplot(data=df, x="EQ_Score", y="C2", ax=axes[1], color="#10B981")
axes[1].set_title("B: Trait EI predicting Relational Solidarity (C2)", fontweight='bold')
plt.tight_layout()
plt.savefig("figures_python/figure2_regression_models.png", dpi=300)
plt.close()

# Fig 3: Boxplots
fig, axes = plt.subplots(1, 3, figsize=(15, 4.5))
palette = {"Low EI": "#EF4444", "Medium EI": "#F59E0B", "High EI": "#10B981"}
for i, m in enumerate(["TI", "C2", "C4"]):
    sns.boxplot(data=df, x="EI_Group", y=m, palette=palette, ax=axes[i], boxprops=dict(alpha=0.7))
    sns.stripplot(data=df, x="EI_Group", y=m, color="black", alpha=0.35, ax=axes[i])
plt.tight_layout()
plt.savefig("figures_python/figure3_group_comparisons.png", dpi=300)
plt.close()

# Fig 4: Pragmatic Breakdown
cats = ['C1', 'C2', 'C3', 'C4', 'C5']
melted = pd.melt(df.groupby('EI_Group')[cats].mean().reset_index(), id_vars=['EI_Group'])
plt.figure(figsize=(9, 5))
sns.barplot(data=melted, x='EI_Group', y='value', hue='variable', palette='Set2')
plt.title("Figure 4: Distribution of Pragmatic Functions Across EI Groups", fontweight='bold')
plt.tight_layout()
plt.savefig("figures_python/figure4_pragmatic_distribution.png", dpi=300)
plt.close()
print("All 4 figures exported to figures_python/")
