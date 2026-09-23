# ==============================================================================
# 02_descriptive_and_normality.py
# Descriptive Statistics, Skewness, Kurtosis, and Shapiro-Wilk Tests
# Author: Pegah Merrikhi
# ==============================================================================
import pandas as pd
import scipy.stats as stats
import os

data_path = "data/dataset_clean_processed.csv" if os.path.exists("data/dataset_clean_processed.csv") else "dataset_full.csv"
df = pd.read_csv(data_path)

focal_cols = ["EQ_Score", "Total_Turns", "Total_TT", "TI", "C1", "C2", "C3", "C4", "C5"]
existing = [c for c in focal_cols if c in df.columns]

print("=== Descriptive Statistics & Normality (N=100) ===")
desc = df[existing].describe().T
desc['median'] = df[existing].median()
desc['skew'] = df[existing].skew()
desc['kurtosis'] = df[existing].kurtosis()

shapiro_p = []
for col in existing:
    stat, p = stats.shapiro(df[col].dropna())
    shapiro_p.append(round(p, 4))
desc['shapiro_p'] = shapiro_p

print(desc[['count', 'mean', 'std', 'median', 'skew', 'kurtosis', 'shapiro_p']])
desc.to_csv("data/table1_descriptives_and_normality.csv")
