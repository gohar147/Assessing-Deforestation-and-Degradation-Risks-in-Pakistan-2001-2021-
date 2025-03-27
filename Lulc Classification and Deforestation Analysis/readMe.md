# Land Use Land Cover (LULC) and Deforestation Analysis in Pakistan (2001–2021)

This repository contains all scripts, workflows, and outputs related to the LULC classification and deforestation modeling conducted over Pakistan between 2001 and 2021. The project leverages Google Earth Engine (GEE), R-based machine learning, and SHAP-based explainability to understand land cover changes and deforestation drivers.

---

## 📂 Project Structure
├── README.md ├── scripts/ │ ├── 01_GEE_LULC_Export.js │ ├── 02_Raster_Alignment.R │ ├── 03_Correlation_VIF_Analysis.R │ ├── 04_LULC_Classification_Modeling.R │ ├── 05_Deforestation_Modeling_RF.R │ ├── 06_SHAP_Analysis.R ├── data/ │ ├── rasters/ # All LULC and predictor rasters │ ├── shapefiles/ # Study area boundaries │ └── predictors/ # Elevation, slope, DFR, climate, etc. ├── outputs/ │ ├── LULC_Maps/ │ ├── Prob_Maps/ │ ├── Metrics/ │ └── SHAP/ └── Maps/



---

## 🌍 Study Area

The study focuses on forest and land change dynamics across the provinces and territories of Pakistan from 2001 to 2021 using 30m resolution data (GLC_FCS30D, Landsat) and ancillary biophysical variables.

---

## 🔧 Methodology Overview

### 1. LULC Classification (2001–2021)
- Landsat 5, 7, and 8 data were used in GEE to generate LULC maps for 2001, 2005, 2010, 2015, and 2021.
- Exported maps include 5 classes:
  - 1: Forest
  - 2: Shrub
  - 3: Crop
  - 4: Urban
  - 5: Barren

### 2. Raster Alignment
- All predictor rasters (topography, distance factors, climate) were resampled, cropped, and masked using the shapefile (`6DisttExtent.shp`) to ensure perfect alignment with LULC rasters.

### 3. Correlation & Multicollinearity
- Pearson correlation matrix and VIF values were computed to assess multicollinearity among predictors.
- Final selected variables include:
  - Elevation, Slope, Aspect, DFR, DFBU, DFW, kNDVI, Temperature, Precipitation

### 4. LULC Modeling (GLM & RF)
- Binary classifiers (GLM & ranger RF) were trained for each class using `lulcc`, `caret`, and `ranger`.
- Accuracy metrics, ROC, and AUC were evaluated per class.
- Result: Probabilistic LULC maps for each class saved as `*_Prob_RF.tif`.

### 5. Deforestation Modeling
- Deforestation = transition from Forest (1) → Non-Forest in next timestep
- RF models trained on forest loss maps (e.g., 2001–2005) using environmental predictors.
- Class imbalance handled using downsampling or class weighting.
- Final models output deforestation probability maps per period and metrics (confusion matrix, AUC, threshold).

### 6. SHAP Explainability
- SHAP values were computed using `iml` to interpret model predictions for deforestation.
- Local and global importance of drivers visualized.
- Outputs: `global_shap_importance.csv`, `local_shap_values.csv`, bar plots.

---

## 📊 Key Outputs

- `/outputs/LULC_Maps/`: Classified maps (2001–2021)
- `/outputs/Prob_Maps/`: Per-class probability rasters from RF
- `/outputs/Metrics/`: Accuracy, confusion matrices, ROC plots
- `/outputs/SHAP/`: SHAP-based global and local explanations

---

## 📦 Software & Libraries

### Google Earth Engine
- GEE JavaScript API for LULC classification

### R (v >= 4.2)
Key libraries:
- `terra`, `raster`, `sf`, `lulcc`
- `ranger`, `caret`, `pROC`, `iml`
- `ggplot2`, `corrplot`, `reshape2`, `dplyr`

---
---

## 📄 Citation

If you use any part of this work, please cite appropriately or contact for collaboration.

---

## 📃 License

This repository is licensed under the [MIT License](LICENSE).















