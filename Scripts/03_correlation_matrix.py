# ==============================================================================
# 03_correlation_matrix.py
# Pearson & Spearman Correlation Matrices with P-values
# Author: Pegah Merrikhi
# ==============================================================================
import pandas as pd
import numpy as np
import scipy.stats as stats
import os

data_path = "data/dataset_clean_processed.csv" if os.path.exists("data/dataset_clean_processed.csv") else "dataset_full.csv"
df = pd.read_csv(data_path)

cols = ["EQ_Score", "Total_Turns", "Total_TT", "TI", "C1", "C2", "C3", "C4", "C5"]
cols = [c for c in cols if c in df.columns]

r_matrix = pd.DataFrame(index=cols, columns=cols, dtype=float)
p_matrix = pd.DataFrame(index=cols, columns=cols, dtype=float)

for c1 in cols:
    for c2 in cols:
        r, p = stats.pearsonr(df[c1].dropna(), df[c2].dropna())
        r_matrix.loc[c1, c2] = round(r, 4)
        p_matrix.loc[c1, c2] = round(p, 5)

print("=== Pearson Correlation Matrix (r) ===")
print(r_matrix)
r_matrix.to_csv("data/correlation_matrix_r.csv")
p_matrix.to_csv("data/correlation_matrix_pvalues.csv")
