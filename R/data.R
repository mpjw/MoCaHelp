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
