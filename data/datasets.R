source("lib/data-lib.R")

cancerDataset <- function(consensus=FALSE) {
	dataDirs <- c(
		"data/cancer-dataset-supernatant/HEALTHY/",
		"data/cancer-dataset-supernatant/LYMPHOMA/",
		"data/cancer-dataset-supernatant/MYELOMA/"
	)
	
	colors <- c("red", "blue", "green")

	loadDirectories(dataDirs, colors, consensus)
}
