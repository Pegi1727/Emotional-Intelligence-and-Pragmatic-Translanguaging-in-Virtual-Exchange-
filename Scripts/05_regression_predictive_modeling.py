# ==============================================================================
# 05_regression_predictive_modeling.py
# Ordinary Least Squares (OLS) Regression Models
# Author: Pegah Merrikhi
# ==============================================================================
import pandas as pd
import statsmodels.api as sm
from statsmodels.formula.api import ols
import os

data_path = "data/dataset_clean_processed.csv" if os.path.exists("data/dataset_clean_processed.csv") else "dataset_full.csv"
df = pd.read_csv(data_path)

print("=== Model 1: TI ~ EQ_Score ===")
m1 = ols('TI ~ EQ_Score', data=df).fit()
print(m1.summary())
print(f"TI: R2 = {m1.rsquared:.4f}, F = {m1.fvalue:.2f}, p = {m1.f_pvalue:.4e}")

print("\n=== Model 2: C2 ~ EQ_Score ===")
m2 = ols('C2 ~ EQ_Score', data=df).fit()
print(m2.summary())
print(f"C2: R2 = {m2.rsquared:.4f}, F = {m2.fvalue:.2f}, p = {m2.f_pvalue:.4e}")

print("\n=== Subtype Regressions ===")
for sub in ["C1", "C3", "C4", "C5"]:
    if sub in df.columns:
        m = ols(f'{sub} ~ EQ_Score', data=df).fit()
        print(f"{sub:15s} | Beta = {m.params['EQ_Score']:7.3f} | p = {m.pvalues['EQ_Score']:.4f} | R2 = {m.rsquared:.3f}")
