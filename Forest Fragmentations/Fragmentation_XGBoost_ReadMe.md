
# Forest Fragmentation Classification using MSPA and XGBoost

This repository provides a complete pipeline for analyzing forest fragmentation using Morphological Spatial Pattern Analysis (MSPA) outputs, reclassifying them into meaningful categories, and training a machine learning model (XGBoost) to predict fragmentation classes based on landscape and environmental predictors. SHAP (SHapley Additive exPlanations) analysis is included for model interpretation.

---

## 🔍 Project Workflow

### 1. MSPA Fragmentation Classes
- Original MSPA maps (e.g., from GUIDOS Toolbox) were created and reclassified into 4 simplified classes:
  - **Core Forest** (`classCore`)
  - **Fragmented** (`classFrag`)
  - **Open/Edge** (`classOpen`)
  - **Non-Forest Background** (`classBG`)

### 2. Reclassification Logic

| Original MSPA Code | Reclassified Class |
|--------------------|--------------------|
| 5 (Core)           | 1 (classCore)      |
| 1,2,3,4,6,7        | 2 (classFrag)      |
| 8,9                | 3 (classOpen)      |
| 0                  | 4 (classBG)        |
| 129 (NoData)       | NA                 |

### 3. Predictor Variables
Predictors used for the classification model:

- LULC (Land Use Land Cover)
- Elevation
- Distance to Roads
- Distance to Built-Up Areas
- Kernel NDVI (kNDVI)
- Temperature (LST)
- Precipitation
- Population Density (resampled)

---

## ⚙️ Model Training

- **Algorithm**: XGBoost (via `caret` package)
- **Sampling**: 20,000 random points sampled; 500 per class used for balance
- **Model Evaluation**: Confusion matrix, variable importance
- **Prediction**: Full raster classified and exported as `xgb_4class_prediction_2021.tif`
- **Probabilities**: Class-wise probability maps exported separately (e.g., `prob_classCore.tif`)

---

## 📊 SHAP Interpretation

Model interpretation using SHAP:

- Feature-level importance via `iml` and `shapviz`
- Class-specific feature contributions
- Dependence plots for important variables (e.g., LULC)
- Combined summary plots for core vs fragmented vs open vs non-forest

---

## 📁 Folder Structure

```text
├── Analysis/
│   └── Frag/
│       ├── mspa_reclassified_2021.tif
│       └── mspa_4class_2021.tif
├── Data/
│   ├── GLC_FCS30D_Exports/
│   ├── Predictors/
│   └── PopUTM2021.tif
├── Maps/
│   └── Combined_SHAP_Frag.png
├── xgb_4class_prediction_2021.tif
├── prob_classCore.tif
├── prob_classFrag.tif
├── prob_classOpen.tif
├── prob_classBG.tif
├── shap_analysis.R
└── mspa_xgboost_pipeline.R

install.packages(c("terra", "sf", "dplyr", "caret", "xgboost", "e1071", "pROC", "iml", "shapviz", "ggplot2"))
