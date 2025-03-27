# Land Use Land Cover (LULC) Change Detection Script (R Language)
# Description: Multi-temporal LULC change detection analysis across multiple intervals


# Load required libraries
library(terra)
library(raster)
library(lulcc)
library(dplyr)
library(ggplot2)

# Load reclassified LULC rasters (each with 5 consistent classes)
lulc_2001 <- rast("path/to/LULC2001.tif")
lulc_2005 <- rast("path/to/LULC2005.tif")
lulc_2010 <- rast("path/to/LULC2010.tif")
lulc_2015 <- rast("path/to/LULC2015.tif")
lulc_2021 <- rast("path/to/LULC2021.tif")

# Create observed LULC raster stack for each time pair
t_periods <- list(
  c(2001, 2005),
  c(2005, 2010),
  c(2010, 2015),
  c(2015, 2021),
  c(2001, 2021)
)

# Define helper function to compute change analysis
process_change <- function(lulc_start, lulc_end, t1, t2) {
  stack <- stack(raster(lulc_start), raster(lulc_end))
  obs <- ObsLulcRasterStack(x = stack, categories = 1:5, labels = paste("Class", 1:5), t = c(t1, t2))
  
  # Cross-tabulate and calculate area in km^2
  change_matrix <- crossTabulate(obs, times = c(t1, t2))
  pixel_area <- 0.02508  # approximate for 500m pixels
  change_km2 <- change_matrix * pixel_area

  # Create transition map
  trans_map <- lulc_start * 10 + lulc_end
  writeRaster(trans_map, sprintf("Analysis/Lulc/%d-%d/Transition_Map_%d_%d.tif", t1, t2, t1, t2), overwrite=TRUE)

  # Deforestation and forest gain maps
  defo_map <- app(trans_map, fun = function(x) ifelse(x %/% 10 == 1 & x %% 10 != 1, x, NA))
  gain_map <- app(trans_map, fun = function(x) ifelse(x %% 10 == 1 & x %/% 10 != 1, x, NA))
  writeRaster(defo_map, sprintf("Analysis/Lulc/%d-%d/Deforestation_Map_%d_%d.tif", t1, t2, t1, t2), overwrite=TRUE)
  writeRaster(gain_map, sprintf("Analysis/Lulc/%d-%d/Forest_Gain_Map_%d_%d.tif", t1, t2, t1, t2), overwrite=TRUE)

  return(list(change_area_km2 = change_km2))
}

# Run for each period
results <- list(
  process_change(lulc_2001, lulc_2005, 2001, 2005),
  process_change(lulc_2005, lulc_2010, 2005, 2010),
  process_change(lulc_2010, lulc_2015, 2010, 2015),
  process_change(lulc_2015, lulc_2021, 2015, 2021),
  process_change(lulc_2001, lulc_2021, 2001, 2021)
)

# Additional calculations like deforestation rates, plotting transitions,
# exporting CSVs, and area summaries should be added per results list.

# End of Script
