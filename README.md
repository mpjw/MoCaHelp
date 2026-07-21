
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MoCaHelp

<!-- badges: start -->

[![R-CMD-check](https://github.com/mpjw/MoCaHelp/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mpjw/MoCaHelp/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/mpjw/MoCaHelp/graph/badge.svg)](https://app.codecov.io/gh/mpjw/MoCaHelp)
<!-- badges: end -->

The goal of MoCaHelp is to provide ancillary functions for working with
MoCaSeq. One focus is I/O, in particular building paths to result files
and loading types of result data.

## Installation

You can install the development version of MoCaHelp from
[GitHub](https://github.com/mpjw/MoCaHelp) with:

``` r
# install.packages("pak")
pak::pak("mpjw/MoCaHelp")
```

## Example

This a basic example for building paths to some common results files
from MoCaSeq.

``` r
library(MoCaHelp)
# single nucleotide variant example filtering for only cancer gene consensus (CGC) variants
get_mocaseq_path(
  sample_name = "SAMPLE_042_TUMOR",
  sample_type = "matched",
  tool_name = "Mutect2",
  postprocessing = "CGC",
  base_path = "/storage/path",
  ignore_not_existing = TRUE
)
#> [1] "/storage/path/SAMPLE_042_TUMOR/results/Mutect2/SAMPLE_042_TUMOR.Mutect2.NoCommonSNPs.OnlyImpact.CGC.txt"

# copy number variants example
get_mocaseq_path(
  sample_name = "SAMPLE_042_TUMOR",
  sample_type = "matched",
  tool_name = "CNVKit",
  result_type = "segments",
  base_path = "/storage/path",
  ignore_not_existing = TRUE
)
#> [1] "/storage/path/SAMPLE_042_TUMOR/results/CNVKit/matched/SAMPLE_042_TUMOR.cns"

# loff of heterozygocity example
get_mocaseq_path(
  sample_name = "SAMPLE_042_TUMOR",
  sample_type = "matched",
  tool_name = "LOH",
  base_path = "/storage/path",
  ignore_not_existing = TRUE
)
#> [1] "/storage/path/SAMPLE_042_TUMOR/results/LOH/SAMPLE_042_TUMOR.VariantsForLOH.txt"
```
