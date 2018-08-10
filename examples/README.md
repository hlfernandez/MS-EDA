# `examples`
This folder contains the following examples of data analysis using 'lib' scripts:
- `clustering`: an example of sample clustering using a heatmap along with a dendrogram to display results.
- `explore-data`: an example showing a heatmap to visually inspect a dataset.
- `jaccard-analysis`: an example of a sample pairwise comparisong using the Jaccard similarity index.
- `pca`: an example of principal component analysis with 3D representation.

## Usage
Examples are prepared to be run from the main directory. That is, you must start R in the main directory (or set it as the working directory with `setwd` function) and then type the example you want to run, for example:
```R
> getwd();
[1] "/opt/github/MS-EDA"
> source("examples/explore-data/explore-data.R")
```