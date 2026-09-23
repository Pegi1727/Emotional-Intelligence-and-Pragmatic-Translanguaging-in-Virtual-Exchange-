# ==============================================================================
# 01_data_preprocessing.py
# Data Validation, Trait EI Tertile Stratification, and Outlier Screening
# Author: Pegah Merrikhi
# ==============================================================================
import pandas as pd
import numpy as np
import os

print("--- Step 1: Loading Dataset ---")
df = None
for p in ["data/dataset_full.csv", "dataset_full.csv", "/mnt/data/dataset_full.csv"]:
    if os.path.exists(p):
        df = pd.read_csv(p)
        break
assert df is not None, "dataset_full.csv not found"

print(f"Dataset shape: {df.shape}")
assert df.shape[0] == 100, "Sample size N must be exactly 100"

print("\n--- Step 2: Stratification (Low <=89, Medium 90-119, High >=120) ---")
def assign_group(score):
    if score <= 89: return "Low EI"
    elif score <= 119: return "Medium EI"
    return "High EI"

df['EI_Group'] = df['EQ_Score'].apply(assign_group)
df["EI_Group"] = pd.Categorical(df["EI_Group"], categories=["Low EI", "Medium EI", "High EI"], ordered=True)
print(df.groupby('EI_Group', observed=False)['EQ_Score'].agg(['count', 'mean', 'std', 'min', 'max']))

print("\n--- Step 3: Outlier Check (|Z| > 3.29) ---")
focal_cols = ["EQ_Score", "Total_Turns", "Total_TT", "TI", "C1", "C2", "C3", "C4", "C5"]
for col in focal_cols:
    if col in df.columns:
        z = (df[col] - df[col].mean()) / df[col].std()
        outliers = (z.abs() > 3.29).sum()
        print(f"  {col}: {outliers} outliers")

os.makedirs("data", exist_ok=True)
df.to_csv("data/dataset_clean_processed.csv", index=False)
print("\nSaved: data/dataset_clean_processed.csv")
