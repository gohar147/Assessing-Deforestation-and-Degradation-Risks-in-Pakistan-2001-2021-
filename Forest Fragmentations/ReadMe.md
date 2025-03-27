## Forest Fragmentation Analysis using MSPA

This repository includes spatial pattern analysis layers generated using Morphological Spatial Pattern Analysis (MSPA) conducted via [GuidosToolbox (GTB)](https://forest.jrc.ec.europa.eu/en/activities/lpa/gtb/), a free, open-source geospatial analysis tool developed by the European Commission’s Joint Research Centre (JRC).

### 🎯 Objective

The purpose of this step was to identify forest spatial configurations such as:
- **Core** (large intact forest patches)
- **Edge** (boundary of core forest)
- **Islet** (small isolated forest fragments)
- **Bridge** (connecting corridors)

These classes are essential in landscape ecology and conservation planning for assessing forest integrity, connectivity, and fragmentation.

### 🛠 Methodology

1. **Software**: [GuidosToolbox (GTB)](https://forest.jrc.ec.europa.eu/en/activities/lpa/gtb/) (installed locally).
2. **Input**: Binary forest mask in GeoTIFF format (Foreground = Forest, Background = Non-forest).
3. **Preprocessing**:
   - Recode raster values to:
     - 2 → Foreground (Forest)
     - 1 → Background (Non-forest)
     - 0 → NoData (optional)
   - Save as 8-bit GeoTIFF with no compression or LZW.

4. **MSPA Parameters**:
   - **Foreground Connectivity**: 8-connected pixels
   - **Edge Width**: 1 (default), equivalent to one pixel thickness
   - **Transition**: Enabled (1)
   - **Intext**: Enabled (1), to distinguish internal/external features

5. **Processing**:
   - Loaded binary forest map into GTB
   - Applied `Image Analysis → Pattern → Morphological → MSPA`
   - Exported output as GeoTIFF and KML overlays

6. **Output**:
   - Forest fragments categorized into MSPA classes:
     - Core (green)
     - Edge (black)
     - Islet (brown)
     - Bridge (red)
     - Perforation, Loop, Branch, Background, Openings (as applicable)

### 📁 Outputs in Repository

- `/mspa_outputs/`: Contains MSPA-classified GeoTIFFs
- `/kml_overlays/`: Google Earth visualization layers
- `/masks/`: Input binary forest masks used for MSPA

### 📚 References

- Vogt, P., & Riitters, K. (2017). *GuidosToolbox: universal digital image object analysis*. European Journal of Remote Sensing. [DOI:10.1080/22797254.2017.1330650](https://doi.org/10.1080/22797254.2017.1330650)
- Soille, P., & Vogt, P. (2009). *Morphological segmentation of binary patterns*. Pattern Recognition Letters. [DOI:10.1016/j.patrec.2008.10.015](https://doi.org/10.1016/j.patrec.2008.10.015)

---

For details on MSPA usage, see the [MSPA Guide (PDF)](https://ies-ows.jrc.ec.europa.eu/gtb/GTB/MSPA_Guide.pdf).

