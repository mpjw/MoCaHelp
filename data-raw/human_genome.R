#' ---
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     keep_md: TRUE
#' ---

#' Code to prepare human genome datasets
#'
#' This code cleans the raw human genome data from inst/extdata to import it as
#' package data. For the moment I reporduce the data shipped with the MoCaSeq
#' pipeline, because I could not identify the source of the raw external data.
#'
#' History:
#'
#' * 2026: Initial data bundling for MoCaSeq related/downstram analyses

suppressPackageStartupMessages(library(data.table))

# Centromeres -----------------------------------------------------------------
centromeres <- fread(
  file.path("inst", "extdata", "human", "GRCh38.p12.centromeres.bed")
)
centromeres[chromosome %notin% c("X", "Y"), index := as.integer(chromosome)]
centromeres[chromosome == "X", index := 23]
centromeres[chromosome == "Y", index := 24]
setorder(centromeres)
GRCh38.p12.centromeres <- centromeres[, .(
  chr = chromosome,
  start,
  end,
  class = "centromere"
)]
usethis::use_data(GRCh38.p12.centromeres, compress = "gzip", overwrite = TRUE)

# Alternative Haplotypes ------------------------------------------------------
alt_haplotypes <- fread(
  file.path("inst", "extdata", "human", "GRCh38.p12.alternative.haplotypes.bed")
)
alt_haplotypes[chromosome %notin% c("X", "Y"), index := as.integer(chromosome)]
alt_haplotypes[chromosome == "X", index := 23]
alt_haplotypes[chromosome == "Y", index := 24]
setorder(alt_haplotypes)
GRCh38.p12.alt.haplotypes <- alt_haplotypes[, .(
  chr = chromosome,
  start,
  end,
  class = "altHaplotype"
)]
usethis::use_data(
  GRCh38.p12.alt.haplotypes,
  compress = "gzip",
  overwrite = TRUE
)

# Regions of Poor Mappabiltiy -------------------------------------------------
# This data was created by Niklas de Andrade-Krätzig. Please refer to him for
# the original source. This code just repoduces the status-quo data.
mappability <- fread(
  file.path("inst", "extdata", "human", "GRCh38.p12.poor.mappability.bed.gz")
)
mappability[chromosome %notin% c("X", "Y"), index := as.integer(chromosome)]
mappability[chromosome == "X", index := 23]
mappability[chromosome == "Y", index := 24]
setorder(mappability)
GRCh38.p12.mappability <- mappability[, .(
  chr = chromosome,
  start,
  end,
  score = 1,
  class = "UmapS36"
)]
usethis::use_data(GRCh38.p12.mappability, compress = "xz", overwrite = TRUE)
