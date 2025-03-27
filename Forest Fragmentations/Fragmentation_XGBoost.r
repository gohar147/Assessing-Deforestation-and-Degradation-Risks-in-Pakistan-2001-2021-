##############################################################################
# SINGLE CONSOLIDATED R SCRIPT: 4-CLASS MSPA & XGBOOST CLASSIFICATION
##############################################################################

#--- Environment Setup ---#
rm(list = ls(all=TRUE))
graphics.off()
gc()
options(scipen = 999)

#--- Load Required Libraries ---#
library(terra)
library(sf)
library(dplyr)
library(caret)
library(xgboost)
library(e1071)
library(pROC)

#--- Working Directory ---#
setwd("D:/Pap-CN")

#--- Load and Reclassify MSPA Raster ---#
mspa_2021 <- rast("Analysis/Frag/mspa_reclassified_2021.tif")
reclass_mat <- matrix(c(
  129, NA, 0, 4, 1, 2, 2, 2, 3, 2,
  4, 2, 5, 1, 6, 2, 7, 2, 8, 3, 9, 3
), ncol = 2, byrow = TRUE)
mspa_4class <- classify(mspa_2021, rcl = reclass_mat)

#--- Load Predictor Variables ---#
lulc2021 <- rast("Data/Aligned_LULC2021.tif")
Elevation <- rast("Data/Predictors/Elevation_cropped.tif")
DistRoad  <- rast("Data/Predictors/Aligned_DFR.tif")
DistBuilt <- rast("Data/Predictors/Aligned_DFBU.tif")
kNDVI     <- rast("Data/Predictors/Aligned_kndvi_Pak.tif")
Temp      <- rast("Data/Predictors/Aligned_temp_Pak.tif")
Ppt       <- rast("Data/Predictors/Aligned_ppt_Pak.tif")
pop2021   <- rast("PopUTM2021.tif")
pop2021_resampled <- project(pop2021, lulc2021, method="bilinear")
predictors_2021 <- c(lulc2021, Elevation, DistRoad, DistBuilt, kNDVI, Temp, Ppt, pop2021_resampled)
names(predictors_2021) <- c("LULC","Elevation","DistRoad","DistBuilt","kNDVI","Temp","Ppt","Population")

#--- Sampling ---#
sample_points <- spatSample(c(mspa_4class, predictors_2021), size=20000, method="random", na.rm=TRUE, as.df=TRUE)
colnames(sample_points)[1] <- "mspa_4class"
sample_points$mspa_4class <- factor(sample_points$mspa_4class)

#--- Class Balancing ---#
balanced_sample <- sample_points %>% group_by(mspa_4class) %>% sample_n(500, replace=TRUE) %>% ungroup()
balanced_sample$mspa_4class <- factor(balanced_sample$mspa_4class, levels = c("1","2","3","4"), labels = c("classCore","classFrag","classOpen","classBG"))

#--- Train/Test Split ---#
set.seed(123)
train_idx  <- createDataPartition(balanced_sample$mspa_4class, p=0.7, list=FALSE)
train_data <- balanced_sample[train_idx, ]
test_data  <- balanced_sample[-train_idx, ]

#--- Model Training ---#
ctrl <- trainControl(method="repeatedcv", number=5, repeats=2, classProbs=TRUE, summaryFunction=multiClassSummary)
train_sampled <- train_data %>% sample_n(1000)
xgb_model <- train(mspa_4class ~ ., data = train_sampled, method = "xgbTree", trControl = ctrl, tuneLength = 3)

#--- Evaluation ---#
pred_test <- predict(xgb_model, newdata = test_data)
conf_mtx <- confusionMatrix(pred_test, test_data$mspa_4class)
print(conf_mtx)

#--- Variable Importance ---#
var_imp <- varImp(xgb_model)
plot(var_imp, main = "Variable Importance (XGBoost)")

#--- Raster Prediction ---#
predict_xgb <- function(model, data, ...) predict(model, newdata=data) %>% as.numeric()
xgb_map_4class <- predict(predictors_2021, model = xgb_model, fun = predict_xgb)
writeRaster(xgb_map_4class, "xgb_4class_prediction_2021.tif", overwrite=TRUE)

#--- Probability Mapping ---#
predict_xgb_prob <- function(model, data, ...) {
  probs <- predict(model, newdata=as.data.frame(data), type="prob")
  as.matrix(probs)
}
xgb_prob_map <- predict(predictors_2021, model = xgb_model, fun = predict_xgb_prob)
names(xgb_prob_map) <- c("prob_class1", "prob_class2", "prob_class3", "prob_class4")
writeRaster(xgb_prob_map, filename = paste0("prob_", names(xgb_prob_map), ".tif"), overwrite = TRUE)

#--- SHAP Analysis (Optional Section Skipped Here for README Clarity) ---#
# See full script for SHAP visualizations and interpretation using shapviz/iml.
