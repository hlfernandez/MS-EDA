source("lib/plot-lib.R")
source("data/datasets.R")

data <- cancerDataset()

binnedPeaksMatrix <- getBinnedPeaksMatrix(data, peakIntensityThreshold=0.05)

data$spectra <- toSpectraList(binnedPeaksMatrix)

result <- jaccardAnalysis(data)

print(result)