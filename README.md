# 🌍 Land Use, Forest Fragmentation & Deforestation Analysis

This repository provides a complete workflow for land use/land cover (LULC) classification, forest fragmentation mapping, and spatiotemporal deforestation analysis using remote sensing data, machine learning (XGBoost), and Google Earth Engine (GEE).

---

## 📁 Repository Structure

text ```
. ├── Forest Fragmentations/ │
    ├── Fragmentation_XGBoost.r
    # XGBoost classification based on MSPA classes │
    ├── Fragmentation_XGBoost_ReadMe.md 
    # Description of methods and outputs │ 
    └── ReadMe.md # README specific to fragmentation analysis

├── Lulc Classification and Deforestation Analysis/ │
    ├── Lulc Change Detection.r
    # Multi-temporal LULC change analysis (2001–2021) │ 
    ├── Lulc Change Detection_ReadMe.md 
    # Step-by-step guide for change detection │
    ├── Lulc Classification Gee.js
    # GEE script for LULC classification │
    ├── lulc and Deforestation Analysis Workflow.js 
    # Full classification + deforestation workflow in GEE │
    └── readMe.md # README specific to classification + change detection
├── LICENSE
