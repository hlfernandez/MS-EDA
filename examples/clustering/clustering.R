source("lib/plot-lib.R")
source("data/datasets.R")

data <- cancerDataset()

heatmap(data, peakIntensityThreshold=0.3)