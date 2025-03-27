# Land Use and Land Cover (LULC) Change Detection (2001–2021)

This repository documents a comprehensive R-based workflow for detecting land cover changes and quantifying deforestation and reforestation patterns over multiple time periods using raster data.

---

---

##  Objectives

- Detect LULC transitions over five time periods (2001–2005, 2005–2010, 2010–2015, 2015–2021, and 2001–2021).
- Map forest loss (deforestation) and gain (reforestation).
- Quantify transition areas (km²) and percentages.
- Generate transition matrices, spatial maps, and transition statistics.
- Calculate annual rates of forest loss and gain.

---

## 🛠️ Methodology Overview

### 1. **Input Data**

- Reclassified LULC rasters (500 m resolution) for the years:
  - 2001, 2005, 2010, 2015, 2021
- Classes used:  
  `1: Forest`, `2: Shrub`, `3: Crop`, `4: Urban`, `5: Barren`, `...`

### 2. **Transition Encoding**

- Transitions encoded as:  
```transition_code = (from_class * 10) + to_class```
Example:  
`13` = Forest (1) → Crop (3)

### 3. **Change Matrix Computation**

- `lulcc::crossTabulate()` used to build pixel-wise change matrices.
- Converted to area (km²) using pixel size.

### 4. **Transition Maps**

- Raster outputs for:
- All transitions
- Forest to non-forest (deforestation)
- Non-forest to forest (reforestation)
- Separate transition maps per period.

### 5. **Statistics & Plots**

- Bar plots for:
- Forest loss by transition type
- Forest gain by transition type
- CSV exports:
- Change matrices (absolute and %)
- Deforestation and reforestation transition areas

### 6. **Deforestation Rate Calculation**

- Based on:
```deforestation_rate = (total_forest_loss / initial_forest_area) * 100 annual_rate = deforestation_rate / years```


---

##  Required R Packages

```install.packages(c("terra", "raster", "lulcc", "ggplot2", "dplyr", "reshape2", "gtools")) ```

## Outputs
- Transition_Map_YYYY_YYYY.tif — Encoded raster of class transitions.
- Deforestation_Map_YYYY_YYYY.tif — Forest → Non-forest raster mask.
- Forest_Gain_Map_YYYY_YYYY.tif — Non-forest → Forest raster mask.
- LULC_AreaKm_YYYY-YYYY.csv — Area-based transition matrix.
- LULC_AreaPercent_YYYY-YYYY.csv — Percentage transition matrix.
- Reforestation_Area_YYYY-YYYY.csv — Area and % by transition type.
- Deforestation_YYYY-YYYY.tif — Binary raster of deforestation locations.

## Notes
All rasters must be aligned in resolution, CRS, and extent.

Class reassignments should be updated if working with different LULC schemes.

Scripts are modular and can be reused across different temporal windows or datasets.
