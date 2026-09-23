# ==============================================================================
# 08_run_full_pipeline.py
# Master Orchestration Script: Executes the complete end-to-end Python pipeline
# Author: Pegah Merrikhi
# ==============================================================================
import subprocess
import sys
import time

modules = [
    "01_data_preprocessing.py",
    "02_descriptive_and_normality.py",
    "03_correlation_matrix.py",
    "04_anova_group_comparisons.py",
    "05_regression_predictive_modeling.py",
    "06_pragmatic_distribution_analysis.py",
    "07_publication_visualizations.py"
]

print("==================================================================")
print("STARTING FULL REPRODUCIBLE PYTHON PIPELINE")
print("==================================================================")

start_time = time.time()
for m in modules:
    print(f"\n>>> Executing {m} ...")
    res = subprocess.run([sys.executable, m], capture_output=False)
    if res.returncode != 0:
        print(f"[ERROR] Module {m} failed with return code {res.returncode}")
        sys.exit(res.returncode)

elapsed = time.time() - start_time
print(f"\n==================================================================")
print(f"[COMPLETED] Pipeline finished successfully in {elapsed:.2f} seconds.")
print("==================================================================")
