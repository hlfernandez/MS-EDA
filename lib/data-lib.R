require("MALDIquant")

loadDirectory <- function(dataDir) {
	spectra <- list.files(dataDir)
	spectraData <- list()
	for (spectrumFile in spectra){
		spectrumFile <- paste(dataDir,"/", spectrumFile, sep='')
		data <- read.csv(spectrumFile)
		spectrum <- createMassPeaks(mass=data[,1], intensity=data[,2], metaData=list(name=spectrumFile))
		spectraData <- c(spectraData, spectrum)
	}
	
	spectraData
}

loadSamples <- function(dataDir) {
	samples <- list.files(dataDir)
	spectra <- list()
	names <- list()
	for (sampleDir in samples){
		sampleDirectory <- paste(dataDir,"/", sampleDir, sep='')
		sampleSpectra <- loadDirectory(sampleDirectory)
		spectra <- c(spectra, sampleSpectra)
		names <- c(names, sapply(1:length(sampleSpectra), FUN=function(x) paste(sampleDir,"_R",x,sep='')))
	}
	
	list(names=names, spectra=spectra)
}

loadDirectories <- function(dataDirs, col) {
	if(missing(col)) {
		palette <- sample(colors(TRUE))[1:length(dataDirs)]
	} else {
		palette <- col[1:length(dataDirs)]
	}
	spectraColors <- list()
	names 	<- list()
	spectra <- list()

	i <- 1
	for (dataDir in dataDirs){
		data <- loadSamples(dataDir)
		names <- unlist(c(names, data$names))
		spectra <- c(spectra, data$spectra)
		spectraColors <- unlist(c(spectraColors, rep(palette[i], length(data$spectra))))
		i <- i+1
	}
	
	list(names=names, spectra=spectra, spectraColors=spectraColors)
}

getBinnedPeaksMatrix <- function(data, tolerance=0.002, peakIntensityThreshold=0) {
	binnedPeaks <- binPeaks(data$spectra, tolerance=tolerance)
	binnedPeaksMatrix <- intensityMatrix(binnedPeaks)
	binnedPeaksMatrix[is.na(binnedPeaksMatrix)] <- 0
	binnedPeaksMatrix <- binnedPeaksMatrix[,apply(binnedPeaksMatrix, 2, max) >= peakIntensityThreshold]
	rownames(binnedPeaksMatrix) <- data$names

	binnedPeaksMatrix
}
