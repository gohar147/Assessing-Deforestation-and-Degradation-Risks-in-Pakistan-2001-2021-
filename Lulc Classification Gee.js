// =========================================
// LAND USE LAND COVER CLASSIFICATION - PAKISTAN
// Using Landsat 5, 7, and 8 Surface Reflectance
// =========================================

// 1. Define Pakistan Boundary
var countries = ee.FeatureCollection("USDOS/LSIB_SIMPLE/2017");
var pakistan = countries.filter(ee.Filter.eq('country_na', 'Pakistan'));
Map.centerObject(pakistan, 6);

// 2. Cloud Masking Function for Landsat SR
function maskSR(image) {
  var qa = image.select('pixel_qa');
  var cloudShadow = qa.bitwiseAnd(1 << 3).eq(0);
  var clouds = qa.bitwiseAnd(1 << 5).eq(0);
  return image.updateMask(cloudShadow.and(clouds)).divide(10000);
}

// 3. Load and Preprocess Landsat 5, 7, 8
var l5 = ee.ImageCollection("LANDSAT/LT05/C01/T1_SR")
  .filterBounds(pakistan)
  .filterDate('2001-01-01', '2011-12-31')
  .map(maskSR)
  .select(['B1','B2','B3','B4','B5','B7'],
          ['Blue','Green','Red','NIR','SWIR1','SWIR2']);

var l7 = ee.ImageCollection("LANDSAT/LE07/C01/T1_SR")
  .filterBounds(pakistan)
  .filterDate('2001-01-01', '2020-12-31')
  .map(maskSR)
  .select(['B1','B2','B3','B4','B5','B7'],
          ['Blue','Green','Red','NIR','SWIR1','SWIR2']);

var l8 = ee.ImageCollection("LANDSAT/LC08/C01/T1_SR")
  .filterBounds(pakistan)
  .filterDate('2013-01-01', '2021-12-31')
  .map(maskSR)
  .select(['B2','B3','B4','B5','B6','B7'],
          ['Blue','Green','Red','NIR','SWIR1','SWIR2']);

// 4. Combine All Collections and Create Composite
var allLandsat = l5.merge(l7).merge(l8);
var composite = allLandsat.median().clip(pakistan);

// 5. Add Spectral Indices
var ndvi = composite.normalizedDifference(['NIR', 'Red']).rename('NDVI');
var ndbi = composite.normalizedDifference(['SWIR1', 'NIR']).rename('NDBI');
var mndwi = composite.normalizedDifference(['Green', 'SWIR1']).rename('MNDWI');
var imageWithIndices = composite.addBands([ndvi, ndbi, mndwi]);

// 6. Load or Digitize Training Data (to be drawn manually in GEE UI)
// Example: var training = ee.FeatureCollection("training_lulc");

// 7. Train Classifier
// var bands = ['Blue','Green','Red','NIR','SWIR1','SWIR2','NDVI','NDBI','MNDWI'];
// var trainingData = imageWithIndices.sampleRegions({
//   collection: training,
//   properties: ['landcover'],
//   scale: 30
// });
// var classifier = ee.Classifier.smileRandomForest(100).train({
//   features: trainingData,
//   classProperty: 'landcover',
//   inputProperties: bands
// });
// var classified = imageWithIndices.select(bands).classify(classifier);

// 8. Visualization (Optional)
// Map.addLayer(classified, 
//   {min: 1, max: 5, palette: ['006400','7FFF00','FFD700','FF4500','8B4513']}, 
//   'LULC Classification');

// 9. Export Classified Map
// Export.image.toDrive({
//   image: classified,
//   description: 'Pakistan_LULC_Classification',
//   folder: 'GEE_Exports',
//   fileNamePrefix: 'LULC_Pakistan_2021',
//   region: pakistan.geometry(),
//   scale: 30,
//   maxPixels: 1e13
// });
