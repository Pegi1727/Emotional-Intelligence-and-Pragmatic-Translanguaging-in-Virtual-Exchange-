# ==============================================================================
# 06_pragmatic_distribution_analysis.py
# Pragmatic Functional Allocation Shifts Across EI Tiers
# Author: Pegah Merrikhi
# ==============================================================================
import pandas as pd
import os

data_path = "data/dataset_clean_processed.csv" if os.path.exists("data/dataset_clean_processed.csv") else "dataset_full.csv"
df = pd.read_csv(data_path)

if 'EI_Group' not in df.columns:
    df['EI_Group'] = df['EQ_Score'].apply(lambda s: "Low EI" if s<=89 else ("Medium EI" if s<=119 else "High EI"))

cats = ['C1', 'C2', 'C3', 'C4', 'C5']
agg = df.groupby('EI_Group')[cats].agg(['mean', 'std'])
print("=== Absolute Pragmatic Frequencies Across EI Tiers ===")
print(agg)

# Relative % composition
df['Total_Functional'] = df[cats].sum(axis=1)
for c in cats:
    df[f"{c}_pct"] = (df[c] / df['Total_Functional']) * 100

pct_cols = [f"{c}_pct" for c in cats]
pct_agg = df.groupby('EI_Group')[pct_cols].mean()
print("\n=== Percentage Allocation Across EI Tiers (%) ===")
print(pct_agg)
pct_agg.to_csv("data/pragmatic_profile_percentages.csv")
