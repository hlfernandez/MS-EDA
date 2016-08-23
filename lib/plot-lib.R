library("gplots")

plotIntensityMatrix <- function(peaksMatrix) {
	colorPalette <- colorpanel(n=10, low="white", high="black");
	
	heatmap.2(
		peaksMatrix,		# peaks matrix
		main = "", 		# heat map title
		notecol="black",	# change font color of cell labels to black
		density.info="none",	# turns off density plot inside color legend
		trace="none",		# turns off trace lines inside the heat map
		margins =c(12,9),	# widens margins around plot
		col=colorPalette,       # use on color palette defined earlier
		dendrogram="none",     	# disable dendogram
		Colv="NA", 		# disable columns clustering
		Rowv="NA"		# disable rows clustering
	)
}

pngOn <- function(file) {
	png(
		file,
		width = 12*300,
		height = 10*300,
		res = 300,
		pointsize = 8
	)
}

pngOff <- function(file) {
	dev.off()
}

pngIntensityMatrix <- function(peaksMatrix, file) {
	pngOn(file)
	plotIntensityMatrix(peaksMatrix)
	pngOff()
}

cor.dist <- function(x){
	as.dist(1- abs(cor(t(x), use="pairwise.complete.obs")))
}

heatmap.matrix <- function(binnedPeaksMatrix, spectraColors) {
	dend <- as.dendrogram(hclust(cor.dist(binnedPeaksMatrix)^2, method="ward")) # Distances must be squared when using ward method

	breaks <- seq(quantile(binnedPeaksMatrix,na.rm=TRUE,probs=0.001),quantile(binnedPeaksMatrix,probs=0.999,na.rm=TRUE),length.out = 24)
		
	heatmap.2(
		binnedPeaksMatrix,
		Colv=FALSE,
		Rowv=dend,
		dendrogram="row",
		breaks=breaks,
		col=bluered(length(breaks)-1),
		scale="none",
		RowSideColors=spectraColors,
		na.color = 'gray',
		distfun=cor.dist,
		hclustfun=hclust.ward,
		lwid=c(2,8),
		trace="none",
		margins =c(12,9),	# widens margins around plot
	)
}

heatmap <- function(data, peakIntensityThreshold=0) {
	binnedPeaksMatrix <- getBinnedPeaksMatrix(data, peakIntensityThreshold=peakIntensityThreshold)
	
	heatmap.matrix(binnedPeaksMatrix, data$spectraColors)
}


pngHeatmap.matrix <- function(binnedPeaksMatrix, spectraColors, file) {
	pngOn(file)
	heatmap.matrix(binnedPeaksMatrix, spectraColors)
	pngOff()
}

pngHeatmap <- function(data, file, peakIntensityThreshold=0) {
	binnedPeaksMatrix <- getBinnedPeaksMatrix(data, peakIntensityThreshold=peakIntensityThreshold)
	
	pngHeatmap.matrix(binnedPeaksMatrix, data$spectraColors, file)
}