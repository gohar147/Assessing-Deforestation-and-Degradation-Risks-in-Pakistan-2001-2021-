# ----------------------------------------------------------------------------
# Title: Pakistan Land Use/Land Cover and Deforestation Analysis Workflow
# Author: [Your Name Here]
# Description: Full pipeline for LULC classification, deforestation probability 
# modeling, SHAP analysis, and accuracy evaluation from 2001 to 2021 using 
# Random Forests in R. Suitable for GitHub archiving and reproducibility.
# ----------------------------------------------------------------------------

# 1. Workspace Preparation ---------------------------------------------------
rm(list = ls(all=TRUE)); gc(); graphics.off()

# 2. Load Required Libraries -------------------------------------------------
library(terra)
library(raster)
library(sf)
library(sp)
library(caret)
library(ranger)
library(pROC)
library(iml)
library(corrplot)
library(ggplot2)
library(reshape2)
library(dplyr)

# 3. Define Paths and Load Inputs -------------------------------------------
setwd("D:/Pap-CN")
shape <- vect("shp/pakistan.shp")
lulc_paths <- list(
  lulc2001 = "Data/GLC_FCS30D_Exports/Aligned_LULC2001.tif",
  lulc2005 = "Data/GLC_FCS30D_Exports/Aligned_LULC2005.tif",
  lulc2010 = "Data/GLC_FCS30D_Exports/Aligned_LULC2010.tif",
  lulc2015 = "Data/GLC_FCS30D_Exports/Aligned_LULC2015.tif",
  lulc2021 = "Data/GLC_FCS30D_Exports/Aligned_LULC2021.tif"
)
predictor_paths <- list(
  Elevation = "Data/Predictors/Elevation_cropped.tif",
  Slope     = "Data/Predictors/Slope_cropped.tif",
  Aspect    = "Data/Predictors/Aspect_cropped.tif",
  DFR       = "Data/Predictors/Aligned_DFR.tif",
  DFBU      = "Data/Predictors/Aligned_DFBU.tif",
  DFW       = "Data/Predictors/Aligned_DFW.tif",
  kNDVI     = "Data/Predictors/Aligned_kndvi_2021.tif",
  Temp      = "Data/Predictors/Aligned_temp_2021.tif",
  Ppt       = "Data/Predictors/Aligned_ppt_2021.tif"
)

# 4. Load and Align Rasters -------------------------------------------------
shape_aligned <- project(shape, crs(rast(lulc_paths$lulc2001)))
lulc_rasters <- lapply(lulc_paths, function(p) mask(crop(rast(p), shape_aligned), shape_aligned))
predictor_rasters <- lapply(predictor_paths, function(p) mask(crop(rast(p), shape_aligned), shape_aligned))

# 5. Prepare Predictor Stack -------------------------------------------------
predictor_stack <- rast(predictor_rasters)
names(predictor_stack) <- names(predictor_paths)

# 6. Sample and Correlation Analysis ----------------------------------------
sample_df <- as.data.frame(na.omit(spatSample(predictor_stack, 10000, method = "random")))
cor_matrix <- cor(sample_df)
corrplot(cor_matrix, method = "circle", type = "lower", tl.cex = 0.8)

# 7. VIF Check ---------------------------------------------------------------
library(car)
vif_data <- data.frame(lapply(predictor_rasters, values))
vif_data <- na.omit(vif_data)
vif_model <- lm(Elevation ~ ., data = vif_data)
vif(car::vif(vif_model))

# 8. Convert terra to raster (lulcc compatible) ------------------------------
lulc_raster_stack <- stack(lapply(lulc_rasters, raster))
names(lulc_raster_stack) <- paste0("lu_", c("2001", "2005", "2010", "2015", "2021"))
predictor_raster_stack <- stack(lapply(predictor_rasters, raster))
names(predictor_raster_stack) <- paste0("ef_", sprintf("%03d", 1:nlayers(predictor_raster_stack)))

# 9. LULC Modeling and Evaluation -------------------------------------------
library(lulcc)
obs <- ObsLulcRasterStack(x = lulc_raster_stack, pattern = "lu", categories = 1:5,
                          labels = c("Forest", "Shrub", "Crop", "Urban", "Barren"),
                          t = c(0, 4, 9, 14, 20))
ef <- ExpVarRasterList(x = predictor_raster_stack, pattern = "ef")
part <- partition(x = obs[[1]], size = 0.3, spatial = TRUE)
train_data <- getPredictiveModelInputData(obs, ef, cells = part$train, t = 0)
test_data  <- getPredictiveModelInputData(obs, ef, cells = part$test)

# 10. Random Forest Classification ------------------------------------------
rf_models <- list()
classes <- c("Forest", "Shrub", "Crop", "Urban", "Barren")
for (cls in classes) {
  train_data[[cls]] <- factor(train_data[[cls]], levels = c(0,1))
  rf_models[[cls]] <- ranger(as.formula(paste(cls, "~ .")), data = train_data, probability = TRUE)
}

# 11. SHAP Analysis for Forest ----------------------------------------------
predictor_df <- train_data[, grep("^ef_", names(train_data), value = TRUE)]
y_forest <- as.numeric(train_data$Forest) - 1
pred_fun <- function(model, newdata) predict(model, data = newdata)$predictions[,2]
pred_iml <- Predictor$new(rf_models[["Forest"]], data = predictor_df, y = y_forest, predict.fun = pred_fun)
shap_values <- Shapley$new(pred_iml, x = predictor_df[1:1000, ])
plot(shap_values)

# 12. Export and Save Results -----------------------------------------------
write.csv(shap_values$results, "Outputs/SHAP_Forest_Class.csv", row.names = FALSE)
# Add export raster predictions and accuracy metrics as needed

# ----------------------------------------------------------------------------
# End of Script
# ----------------------------------------------------------------------------
