source("lib/data-lib.R")

cancerDataset <- function() {
	set.seed(33);
	
	dataDirs <- c(
		"data/cancer-dataset-supernatant/HEALTHY/",
		"data/cancer-dataset-supernatant/LYMPHOMA/",
		"data/cancer-dataset-supernatant/MYELOMA/"
	)

	loadDirectories(dataDirs) 
}
