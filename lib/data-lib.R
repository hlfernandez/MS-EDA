require("MALDIquant")

var.m <- function(x) {
	diferences <- x-mean(x)
	sum(diferences*diferences)/length(x)
}

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

asPresenceMatrix <- function(data) {
	toret <- data
	toret[data > 0] <- 1;
	toret[data == NA] <- 0;
	toret
}

data.subset <- function(data, from, to) {
	list(names=data$names[from:to], spectra=data$spectra[from:to], spectraColors=data$spectraColors[from:to])
}

jaccard <- function(a, b) {
	length(intersect(a,b)) / length(union(a, b))
}

#
# This function returns a data matrix where all samples in the input data are compared in pairs by calculating
# the Jaccard similarity index (https://en.wikipedia.org/wiki/Jaccard_index).
# 
# The parameter data must have the structure returned by the loadDirectories or loadSamples functions, that is,
# it must have data$names and a data$spectra variables.
#
# Note that the spectra must been binned or matched before, so that they are comparable in terms of peak presence.
#
jaccardAnalysis <- function(data) {
	result <- c()

	for(i in 1:length(data$spectra)) {
		currentValues <- rep(NA, length(data$names))
		for(j in i:length(data$spectra)) {
			massesA <- mass(data$spectra[[i]])
			massesB <- mass(data$spectra[[j]])
			currentValues[j] <- jaccard(massesA, massesB)
		}
		result <- rbind(result, currentValues)
	}

	rownames(result) <- data$names
	colnames(result) <- data$names
	result
}

#
# Converts a binned peaks matrix into a list of MassPeak objects.
#
toSpectraList <- function(binnedPeaksMatrix) {
	spectraData <- list()

	for(i in 1:nrow(binnedPeaksMatrix)) {
		intensities <- as.numeric(binnedPeaksMatrix[i,])
		masses <- as.numeric(as.character(colnames(binnedPeaksMatrix)))

		masses <- masses[intensities > 0]
		intensities <- intensities[intensities > 0]

		spectrum <- createMassPeaks(mass=masses, intensity=intensities, metaData=list(name=rownames(binnedPeaksMatrix)[i]))
		spectraData <- c(spectraData, spectrum)
	}
	spectraData
}
