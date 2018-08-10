# `jaccard-analysis`
This example creates a matrix comparing all samples in the dataset by calculating the [Jaccard similarity index](https://en.wikipedia.org/wiki/Jaccard_index).

It uses the `getBinnedPeaksMatrix` function to align the dataset. The `peakIntensityThreshold` is used to filter out peaks that do not have reach this threshold in all samples. Then, the spectra list is extracted from the matrix by using the `toSpectraList` function, and finally the `jaccardAnalysis` function is used to create the symmetric matrix containing the samples paiwrise comparisons.

```R
> head(result)
      HA_R1     HA_R2     HA_R3     HA_R4     HA_R5     HB_R1     HB_R2
HA_R1     1 0.8392857 0.8285714 0.8660714 0.8454545 0.7886179 0.8035714
HA_R2    NA 1.0000000 0.8285714 0.8828829 0.8796296 0.7886179 0.8035714
HA_R3    NA        NA 1.0000000 0.8055556 0.8000000 0.7166667 0.7904762
HA_R4    NA        NA        NA 1.0000000 0.8899083 0.8278689 0.8303571
HA_R5    NA        NA        NA        NA 1.0000000 0.8083333 0.7767857
HB_R1    NA        NA        NA        NA        NA 1.0000000 0.7560976
```