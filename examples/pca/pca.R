source("data/datasets.R")

data <- cancerDataset()

binnedPeaksMatrix <- getBinnedPeaksMatrix(data, peakIntensityThreshold=0.05)

pc <- prcomp(binnedPeaksMatrix)

library(rgl)
plot3d(pc$x[,1:3], col=data$spectraColors)