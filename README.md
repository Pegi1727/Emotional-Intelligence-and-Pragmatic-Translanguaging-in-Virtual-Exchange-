# Emotional Intelligence and Pragmatic Translanguaging in Virtual Exchange: A Quantitative Analysis of Interactional Patterns

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8%2B-blue.svg)](https://www.python.org/)
[![R 4.0+](https://img.shields.io/badge/R-4.0%2B-276DC3.svg)](https://www.r-project.org/)

---

## 📊 Graphical Abstract

<p align="center">
  <img src="figures/graphical-abstract.png" alt="Graphical-Abstract" width="85%"/>
</p>

---

## 📖 Overview
This repository contains the complete replication dataset, analysis pipelines (in both **Python** and **R**), Jupyter notebooks, and publication-ready figures for the study:  
> **"Emotional Intelligence and Pragmatic Translanguaging in Virtual Exchange: A Quantitative Analysis of Interactional Patterns"**  
> **Author:** Pegah Merrikhi  

The research investigates how **Trait Emotional Intelligence (TEIQue-SF)** influences **pragmatic translanguaging behaviors** (such as clarification, relational solidarity, accommodation, language persistence, and sequential practices) among participants ($N = 100$) in virtual exchange environments.

---

## 📈 Key Results & Statistical Summary

| Independent Variable | Dependent Variable / Metric | Statistical Test | $r$ / $\beta$ | $R^2$ | $F$-Statistic | $p$-value |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Trait EI (Total)** | Translanguaging Index (TI) | Pearson & Regression | $.509$ | $.259$ | $F(1,98) = 34.23$ | $< .001$ |
| **Trait EI (Total)** | Relational Solidarity (%) | Pearson & Regression | $.913$ | $.834$ | $F(1,98) = 491.10$ | $< .001$ |
| **Trait EI (Total)** | Clarification Functions (C1) | Correlation | $.923$ | — | — | $< .001$ |
| **Trait EI (Total)** | Clarification Functions (C2) | Correlation | $.954$ | — | — | $< .001$ |
| **EQ Groups (Tertiles)** | Pragmatic Shifts & Patterns | One-Way ANOVA & Tukey HSD | — | — | Significant Group Variance | $< .01$ |

### 🖼️ Publication Figures Showcase

<p align="center">
  <img src="figures/figure1_correlation_matrix.png" alt="Figure 1: Correlation Matrix" width="48%"/>
  <img src="figures/figure2_regression_models.png" alt="Figure 2: Regression Models" width="48%"/>
</p>
<p align="center">
  <img src="figures/figure3_group_comparisons.png" alt="Figure 3: Group Comparisons" width="48%"/>
  <img src="figures/figure4_pragmatic_distribution.png" alt="Figure 4: Pragmatic Distribution" width="48%"/>
</p>

---

## 🎯 Conclusion
1. **Strong Predictive Power of EI:** Trait emotional intelligence significantly predicts overall translanguaging index ($R^2 = .259$) and accounts for a vast proportion of variance in relational solidarity ($R^2 = .834$).
2. **Pragmatic Mediation:** Participants with higher emotional intelligence levels (High-EI tertile) demonstrate superior adaptive strategies, higher frequency of supportive clarification moves, and more effective accommodation in virtual bilingual/multilingual interactions.
3. **Implications:** Emotional intelligence is a core predictor of pragmatic success in digital intercultural communication, highlighting the necessity of integrating socio-emotional skill development into virtual exchange frameworks.

---

## 🗂️ Repository Structure
```text
├── main document.docx                # Full manuscript document
├── README.md                         # Repository documentation
├── requirements.txt                  # Python dependencies
├── environment.yml                   # Conda environment configuration
├── figures/                          # Publication-ready figures & graphical abstract
│   ├── figure1_correlation_matrix.png
│   ├── figure2_regression_models.png
│   ├── figure3_group_comparisons.png
│   ├── figure4_pragmatic_distribution.png
│   └── graphical_abstract.png
├── data/                             # Raw & clean datasets
│   ├── dataset_full.csv
│   ├── dataset_clean_outliers_removed.csv
│   ├── correlation_matrix_P01_P100.csv
│   └── descriptive_stats_P01_P100.csv
├── processed_data/                   # 21 structured processed datasets & JSON codebook
│   ├── 01_cleaned_data_standardized_zscores.csv
│   ├── ...
│   └── 20_data_dictionary_and_codebook.json
├── python_scripts/                   # Modular Python analysis pipeline (01 to 08)
│   ├── 01_data_preprocessing.py
│   ├── ...
│   └── 08_run_full_pipeline.py
├── notebooks/                        # Interactive Jupyter Notebooks (01 to 07)
│   ├── 01_data_preprocessing.ipynb
│   └── ...
└── r_scripts/                        # R analysis pipeline (01 to 05)
├── 01_data_preprocessing.R
└── ...
