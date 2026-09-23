# ==============================================================================
# 04_anova_group_comparisons.py
# Levene's Test, One-Way ANOVA, Kruskal-Wallis, and Tukey HSD
# Author: Pegah Merrikhi
# ==============================================================================
import pandas as pd
import scipy.stats as stats
import statsmodels.api as sm
from statsmodels.formula.api import ols
from statsmodels.stats.multicomp import pairwise_tukeyhsd
import os

data_path = "data/dataset_clean_processed.csv" if os.path.exists("data/dataset_clean_processed.csv") else "dataset_full.csv"
df = pd.read_csv(data_path)

if 'EI_Group' not in df.columns:
    df['EI_Group'] = df['EQ_Score'].apply(lambda s: "Low EI" if s<=89 else ("Medium EI" if s<=119 else "High EI"))

targets = ["TI", "C1", "C2", "C3", "C4", "C5"]
for target in targets:
    if target not in df.columns: continue
    print(f"\n================ ANOVA: {target} ================")
    groups = [grp[target].dropna() for _, grp in df.groupby('EI_Group')]
    
    # Levene
    l_stat, l_p = stats.levene(*groups)
    print(f"Levene Test: F = {l_stat:.3f}, p = {l_p:.4f}")
    
    # ANOVA
    model = ols(f"{target} ~ C(EI_Group)", data=df).fit()
    table = sm.stats.anova_lm(model, typ=2)
    eta_sq = table['sum_sq'].iloc[0] / table['sum_sq'].sum()
    print(table)
    print(f"Eta-squared: {eta_sq:.4f}")
    
    # Tukey HSD
    tukey = pairwise_tukeyhsd(df[target], df['EI_Group'], alpha=0.05)
    print("Tukey HSD:")
    print(tukey.summary())
