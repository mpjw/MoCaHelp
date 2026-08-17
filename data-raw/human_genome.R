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

hg38p12_download_link <- "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.27_GRCh38.p12/GCA_000001405.27_GRCh38.p12_assembly_regions.txt"
regions_file <- "data-raw/GRCh38.p12_assembly_regions.txt"

curl::curl_download(hg38p12_download_link, regions_file)

dt_regions <- data.table::fread(regions_file, skip = 58, header = TRUE)
colnames(dt_regions)[1] <- gsub("# ", "", colnames(dt_regions)[1])
colnames(dt_regions) <- gsub("-", "", colnames(dt_regions))

# take centromoeres from downloaded file over Niklas annotation
centromeres <- dt_regions[
  ScaffoldRole == "CEN",
  .(chromosome = Chromosome, start = ChromosomeStart, end = ChromosomeStop)
]

# Niklas annotation lists more alternative haplotypes than the downloaded file
alt_haplotypes <- dt_regions[
  ScaffoldRole == "alt-scaffold",
  .(
    chromosome = Chromosome,
    start = ChromosomeStart,
    end = ChromosomeStop,
    genbank = ScaffoldGenBankAccn,
    refseq = ScaffoldRefSeqAccn
  )
]

curl::curl_download(
  "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.27_GRCh38.p12/GCA_000001405.27_GRCh38.p12_assembly_structure/all_alt_scaffold_placement.txt",
  "data-raw/GRCh38.p12_all_alt_scaffolds.txt"
)
curl::curl_download(
  "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.24_GRCh38.p9/GCA_000001405.24_GRCh38.p9_assembly_structure/all_alt_scaffold_placement.txt",
  "data-raw/GRCh38.p9_all_alt_scaffolds.txt"
)
dt_scaffolds <- data.table::fread("data-raw/GRCh38.p12_all_alt_scaffolds.txt")
dt_scaffolds <- unique(dt_scaffolds[, .(
  chromosome = parent_name,
  start = parent_start,
  end = parent_stop
)])
dt_scaffolds[, uniq_id := paste(chromosome, start, end, sep = "_")]

# TODO compare with
# https://hgdownload.gi.ucsc.edu/goldenPath/hg38/bigZips/
# https://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/
# https://genome.ucsc.edu/cgi-bin/hgTrackUi?hgsid=4131087549_W3avAs408T7B9HaQxNu62mCeduGz&db=hg38&c=chr7&g=problematicSuper

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
# Single-read and multi-read mappability by Umap
# See: https://academic.oup.com/nar/article/46/20/e120/5086676
#
# To optain the this raw data, please refer to the UCSC genome browser:
# https://genome.ucsc.edu/cgi-bin/hgTrackUi?hgsid=4130326217_arlrjAZ2JvsUWkVGiZLecfAPjiOT&db=hg38&c=chr1&g=umap
#
# bigBedToBed http://hgdownload.soe.ucsc.edu/gbdb/hg38/hoffmanMappability/k36.Unique.Mappability.bb GRCh38.p12.poor.mappability.bed
# gzip GRCh38.p12.poor.mappability.bed
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
