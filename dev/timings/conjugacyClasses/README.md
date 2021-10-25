# Introduction
The files in this directory are used to compute timings for computing the conjugacy classes in a wreath product.

# Main Files
- `parameters.py` : stores global variables, in particular the considered wreath products
- `startTimings.py` : generates timings **with and without** package for each wreath product and in a new GAP session

# Other Files
- `genTimingWithPackage.g` : generates timings **with** package for a single wreath product
- `genTimingWithoutPackage.g` : generates timings **without** package for a single wreath product

# Output
- `out_timingsWithPackage` : file with timings **with** package for each wreath product
- `out_timingsWithoutPackage` : file with timings **without** package for each wreath product
- `out_timings.csv` : file with timings **with and without** package for each wreath product

# Running Timings
In order to generate the output with timings, one needs to execute `python startTimings.sh [GAP]` from this directory, where `[GAP]` should be the path to a GAP installation.

## Dependencies
- python3