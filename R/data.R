#' Centromeres of human genome v38p12
#'
#' A table of chromosomal coordinates of the centromeres in the human reference
#' genome (GRCh38.p12).
#'
#' @format ## `GRCh38.p12.centromeres`
#' A data frame with 24 rows and 4 columns:
#' \describe{
#'   \item{chr}{Chromosome name}
#'   \item{start, end}{Chromosomal coordinates of start and end position}
#'   \item{class}{Class of genomics region. Here: centromere}
#'   ...
#' }
#' @source <http://genome.ucsc.edu/cgi-bin/hgTables>
"GRCh38.p12.centromeres"

#' Alternative haplotypes of human genome v38p12
#'
#' A table of chromosomal coordinates of alternative haplotypes for the human
#' reference genome (GRCh38.p12).
#'
#' @format ## `GRCh38.p12.alt.haplotypes`
#' A data frame with 24 rows and 4 columns:
#' \describe{
#'   \item{chr}{Chromosome name}
#'   \item{start, end}{Chromosomal coordinates of start and end position}
#'   \item{class}{Class of genomics region. Here: altHaplotype}
#'   ...
#' }
#' @source <http://genome.ucsc.edu/cgi-bin/hgTables>
"GRCh38.p12.alt.haplotypes"

#' Regions of poor mappavility of human genome v38p12
#'
#' A table of chromosomal coordinates for genomic regions of poor mappability
#' in the human reference genome (GRCh38.p12). These regions are poorly aligned
#' to the reference genome and will be prone to observe artifacts in sequencing
#' data.
#'
#' @format ## `GRCh38.p12.mappability`
#' A data frame with 24 rows and 4 columns:
#' \describe{
#'   \item{chr}{Chromosome name}
#'   \item{start, end}{Chromosomal coordinates of start and end position}
#'   \item{class}{Class of genomics region. Here: UmapS36}
#'   ...
#' }
#' @source <http://genome.ucsc.edu/cgi-bin/hgTables>
"GRCh38.p12.mappability"

#' Loads genomic ancillary regions
#'
#' This function loads genomic regions depending on a species (and reference
#' genome version). Available options are chromosomes, centromeres, alternative
#' haplotypes, and regions of poor mappability.
#'
#' @param species Character name of species, i.e. "human" or "mouse".
#' @param region_type Character specifying the type of regions to return. I.e.
#'  one of "chromosomes", "centromeres", "alt.haplotypes", or "mappability".
#' @param ref_genome Character name of reference genome to use for species. Per
#'  default (NULL) GRCh38.p12 and GRCm38.p6 will be used.
#' @param return_granges Logical if to return results as GenomicRanges, returns
#'  a data.table by default (FALSE).
#' @returns \code{data.table::data.table} or \code{GenomicRanges::GRanges}
#'  listing genomic regions.
#' @importFrom utils data
#' @importFrom GenomicRanges makeGRangesFromDataFrame
#' @export
load_genomic_regions <- function(
  species,
  region_type,
  ref_genome = NULL,
  return_granges = FALSE
) {
  stopifnot(
    region_type %in%
      c("chromosomes", "centromeres", "alt.haplotypes", "mappability")
  )

  # determine reference genome
  if (is.null(ref_genome)) {
    ref_genome <- switch(species, human = "GRCh38.p12", mouse = "GRCm38.p6")
  }

  stopifnot(
    ref_genome %in% c("GRCh38.p12", "GRCm38.p6")
  )

  # load data
  .env <- new.env()
  data_set <- paste0(ref_genome, ".", region_type)
  utils::data(list = data_set, envir = .env)[1]
  regions <- .env[[data_set]]

  # convert to genomic ranges object if requested
  if (return_granges) {
    regions <- GenomicRanges::makeGRangesFromDataFrame(
      regions,
      keep.extra.columns = TRUE
    )
  }

  regions
}
