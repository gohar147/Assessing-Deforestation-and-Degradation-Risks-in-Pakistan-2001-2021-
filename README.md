# 🌍 Land Use, Forest Fragmentation & Deforestation Analysis

This repository provides a complete workflow for land use/land cover (LULC) classification, forest fragmentation mapping, and spatiotemporal deforestation analysis using remote sensing data, machine learning (XGBoost), and Google Earth Engine (GEE).

---

## 📁 Repository Structure

```
.
├── Forest Fragmentations/
│   ├── Fragmentation_XGBoost.r                      # XGBoost classification based on MSPA classes
│   ├── Fragmentation_XGBoost_ReadMe.md              # Description of methods and outputs
│   └── ReadMe.md                                    # README specific to fragmentation analysis

├── Lulc Classification and Deforestation Analysis/
│   ├── Lulc Change Detection.r                      # Multi-temporal LULC change analysis (2001–2021)
│   ├── Lulc Change Detection_ReadMe.md              # Step-by-step guide for change detection
│   ├── Lulc Classification Gee.js                   # GEE script for LULC classification
│   ├── lulc and Deforestation Analysis Workflow.js  # Full classification + deforestation workflow in GEE
│   └── readMe.md                                    # README specific to classification + change detection

├── LICENSE
```




---

## 🔍 Project Overview

This study focuses on monitoring land use transformation and forest dynamics in response to anthropogenic and ecological drivers. It integrates:

- Google Earth Engine for supervised LULC classification (Landsat 5/7/8, Sentinel)
- GUIDOS Toolbox for MSPA-based fragmentation mapping
- R-based post-processing for classification, modeling, and transition analysis
- XGBoost machine learning for 4-class forest structure prediction
- SHAP explainability for feature importance
- Multi-year forest loss/gain tracking

---

## 🌳 Forest Fragmentation Analysis

- **Data Source:** MSPA outputs from GUIDOS Toolbox
- **Workflow:**
  - Reclassify original 10 MSPA classes to 4 general classes:
    - Core
    - Fragmented
    - Open
    - Background
  - Stack predictors (LULC, NDVI, DEM, population, climate)
  - Train XGBoost classifier
  - Predict spatially and export probability layers
  - Explain model behavior using SHAP values
- **Tools:** `terra`, `xgboost`, `caret`, `iml`, `shapviz`

📄 Refer to: `Forest Fragmentations/Fragmentation_XGBoost_ReadMe.md`

---

## 🛰️ LULC Classification & Google Earth Engine

- **Scripts:**
  - `Lulc Classification Gee.js`
  - `lulc and Deforestation Analysis Workflow.js`

- **Key Steps:**
  - Load Landsat & Sentinel imagery
  - Apply cloud & shadow masking
  - Create seasonal composites
  - Train supervised classifiers (RF/SVM)
  - Export multi-year classification maps (2001, 2005, 2010, 2015, 2021)

---

## 📉 LULC Change Detection & Transition Analysis

- **Script:** `Lulc Change Detection.r`
- **Temporal Comparisons:**
  - 2001–2005
  - 2005–2010
  - 2010–2015
  - 2015–2021
  - 2001–2021 (overall)

- **Analysis Performed:**
  - Area and percent change per class
  - Cross-tabulated transition matrices
  - Forest loss and forest gain maps
  - Deforestation and reforestation quantification
  - Visualizations via `ggplot2`
  - Annual rate of deforestation calculations

📄 Refer to: `Lulc Classification and Deforestation Analysis/Lulc Change Detection_ReadMe.md`

---

## 📊 Machine Learning: XGBoost

- Balanced sample generation (500 per class)
- Feature set: LULC, Elevation, Distance to roads/built-up, NDVI, Temp, Ppt, Population
- Evaluation:
  - Confusion matrix
  - Class-specific probabilities
  - SHAP plots for feature interpretation

---

##  Outputs

- Predicted MSPA fragmentation map (Core/Frag/Open/Background)
- LULC change transition rasters for each period
- Forest gain and deforestation raster outputs
- `.csv` tables of transition areas and percentages
- SHAP summary plots for variable contribution

---

##  R Libraries Required

```r
install.packages(c("terra", "raster", "sf", "caret", "xgboost",
                   "e1071", "dplyr", "pROC", "shapviz", "iml", 
                   "ggplot2", "reshape2", "lulcc"))
```

## License
This project is licensed under the MIT License.

## Contact
Your Gohar
Vegetation Remote Sensing & Machine Learning
Email: 













