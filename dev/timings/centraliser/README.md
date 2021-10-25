# Introduction
The files in this directory are used to compute timings for computing the centraliser of an element in a wreath product.

# Main Files
- `parameters.py` : stores global variables, in particular the considered wreath products
- `initRandomElements.py` : generates random elements for each wreath product in a new GAP session
- `startTimings.py` : generates timings with and without package for each wreath product and each random element in a new GAP session

# Other Files
- `genRandomElements.g` : generates `NrRandomElements` many random elements for a single wreath product
- `genTimingWithPackage.g` : generates timings **with** package for a single wreath product and a single random elements
- `genTimingWithoutPackage.g` : generates timings **without** package for a single wreath product and a single random elements

# Output
- `out_randomElements/` : dir with random elements for each wreath product
- `out_timingsWithPackage/` : dir with timings **with** package for each wreath product and each pair of random elements
- `out_timingsWithoutPackage/` : dir with timings **without** package for each wreath product and each pair of random elements
- `out_timings.csv` : file with average timings **with and without** package for each wreath product

# Generating Random Elements
We use the same random elements for the timings whether the package is loaded or unloaded.
One can regenerate the random elements by running `python initRandomElements.py [GAP]` from this directory, where `[GAP]` should be the path to a GAP installation.

# Running Timings
In order to generate the output with timings, one needs to execute `python startTimings.py [GAP]` from this directory, where `[GAP]` should be the path to a GAP installation.

## Dependencies
- python3
- python package `tqdm`