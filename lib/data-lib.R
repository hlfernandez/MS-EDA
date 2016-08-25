require("MALDIquant")

loadDirectory <- function(dataDir, consensus=FALSE, tolerance=0.002, POP=0.5) {
	spectra <- list.files(dataDir)
	spectraData <- list()
	for (spectrumFile in spectra){
		spectrumFile <- paste(dataDir,"/", spectrumFile, sep='')
		data <- read.csv(spectrumFile)
		spectrum <- createMassPeaks(mass=data[,1], intensity=data[,2], metaData=list(name=spectrumFile))
		spectraData <- c(spectraData, spectrum)
	}
	
	if(consensus) {
		binnedPeaks <- binPeaks(spectraData, tolerance=0.002);
		binnedPeaksMatrix <- intensityMatrix(binnedPeaks);
		
		consensusMasses <- vector()
		consensusIntensities <- vector()
		
		for (i in 1:ncol(binnedPeaksMatrix)){
			presences = 0;
			for (j in 1:length(binnedPeaksMatrix[,i])){
				if (!is.na(binnedPeaksMatrix[j,i])) presences = presences+1;
			}
			if (presences> (POP * length(binnedPeaksMatrix[,i]))){
				consensusMasses <- c(consensusMasses, colnames(binnedPeaksMatrix)[i])
				consensusIntensities <- c(consensusIntensities, mean(binnedPeaksMatrix[,i], na.rm=TRUE))
			}
		}
		spectrum <- createMassPeaks(
			mass=as.numeric(consensusMasses), 
			intensity=as.numeric(consensusIntensities), 
			metaData=list(name="consensus")
		)
		spectraData <- list()
		spectraData <- c(spectraData, spectrum)
	} 
	
	spectraData
}

loadSamples <- function(dataDir, consensus=FALSE, tolerance=0.002, POP=0.5) {
	samples <- list.dirs(dataDir, full.names=FALSE, recursive=FALSE)
	spectra <- list()
	names <- list()
	for (sampleDir in samples){
		sampleDirectory <- paste(dataDir,"/", sampleDir, sep='')
		sampleSpectra <- loadDirectory(sampleDirectory, consensus, tolerance, POP)
		spectra <- c(spectra, sampleSpectra)
		names <- c(names, sapply(1:length(sampleSpectra), FUN=function(x) paste(sampleDir,"_R",x,sep='')))
	}
	
	list(names=names, spectra=spectra)
}

loadDirectories <- function(dataDirs, col, consensus=FALSE, tolerance=0.002, POP=0.5) {
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
		data <- loadSamples(dataDir, consensus, tolerance, POP)
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
