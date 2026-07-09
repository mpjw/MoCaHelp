#' Genomic data and functions
#'
#' This script contains global genomic variables and genomic functions relevent
#' to the MoCaSeq pipeline.
#'
#' @name genome.R
NULL

# GRCh38p12 (hg38) chromosome lengths
HG38_AUTOMOSOME_SIZES <- c(
  "1" = 248956422,
  "2" = 242193529,
  "3" = 198295559,
  "4" = 190214555,
  "5" = 181538259,
  "6" = 170805979,
  "7" = 159345973,
  "8" = 145138636,
  "9" = 138394717,
  "10" = 133797422,
  "11" = 135086622,
  "12" = 133275309,
  "13" = 114364328,
  "14" = 107043718,
  "15" = 101991189,
  "16" = 90338345,
  "17" = 83257441,
  "18" = 80373285,
  "19" = 58617616,
  "20" = 64444167,
  "21" = 46709983,
  "22" = 50818468
)

HG38_SEX_CHROMOSOME_SIZES <- c(
  "X" = 156040895,
  "Y" = 57227415
)

# GRCm38p6 (mm10) chromosome lengths
MM10_AUTOMOSOME_SIZES <- c(
  "1" = 195471971,
  "2" = 182113224,
  "3" = 160039680,
  "4" = 156508116,
  "5" = 151834684,
  "6" = 149736546,
  "7" = 145441459,
  "8" = 129401213,
  "9" = 124595110,
  "10" = 130694993,
  "11" = 122082543,
  "12" = 120129022,
  "13" = 120421639,
  "14" = 124902244,
  "15" = 104043685,
  "16" = 98207768,
  "17" = 94987271,
  "18" = 90702639,
  "19" = 61431566
)

MM10_SEX_CHROMOSOME_SIZES <- c(
  "X" = 171031299,
  "Y" = 91744698
)

#' Define chromosome sizes based on species.
#'
#' @param species Character name of spieces one of "Human" or "Mouse"
#' @param only_autosomes Logical if to include only autosomes. Default: TRUE
define_chromosome_sizes <- function(species = "Human", only_autosomes = TRUE) {
  switch(
    species,
    "Human" = if (only_autosomes) {
      HG38_AUTOMOSOME_SIZES
    } else {
      c(HG38_AUTOMOSOME_SIZES, HG38_SEX_CHROMOSOME_SIZES)
    },
    "Mouse" = if (only_autosomes) {
      MM10_AUTOMOSOME_SIZES
    } else {
      c(MM10_AUTOMOSOME_SIZES, MM10_SEX_CHROMOSOME_SIZES)
    }
  )
}

#' Process count data from LOH
#'
#' Version 2 uses data.table::fread instead of read.table.
#' TODO: remove undefined dependencies
#'
#' @param chromosome_sizes Integer vector of chomosome sizes with chromosome
#' names
#' @param count_data Character path to count data
#' @param method Character tool name for copy number calling or LOH.
process_count_data <- function(
  chromosome_sizes,
  count_data = "",
  method = ""
) {
  out_list <- list()
  count_data <- data.table::fread(count_data, header = TRUE, sep = "\t")
  SetVariableNames(method)
  out_list <- ConvertGenomicCords(
    data.frame(count_data),
    chromosome_sizes,
    Start,
    CopyNumber,
    Chromosome
  )
  return(out_list)
}

#' Convert genomic coordinates to a single continuous x axis for plotting
#'
#' @param dt_bins data.table holding genomic bins with columns
#' * Chrom
#' * start
#' * end
convert_genomic_to_continuous_axis <- function(dt_bins) {
  dt_bins[, Chrom := as.numeric(Chrom)]
  data.table::setorder(dt_bins, Chrom)
  dt_bins[, start := as.numeric(start)]
  dt_bins[, end := as.numeric(end)]
  # TODO: try leverage base::cumsum here
  Len <- dt_bins[Chrom == 1, max(end)]
  LabelPos <- Len / 2
  Lentmp <- Len
  chromosomes <- as.character(dt_bins[Chrom != 1, unique(Chrom)])
  dt_bins[Chrom == 1, plotstart := start]
  dt_bins[Chrom == 1, plotend := end]
  for (chromosome in chromosomes) {
    Lentmp <- Lentmp + dt_bins[Chrom == chromosome, max(end)]
    dt_bins[Chrom == chromosome, plotstart := start + max(Len)]
    dt_bins[Chrom == chromosome, plotend := end + max(Len)]
    labelpos <- (max(dt_bins[Chrom == chromosome, "end"]) / 2) +
      (max(Len) / 2)
    LabelPos <- c(LabelPos, labelpos)
    Len <- c(Len, Lentmp)
  }
  return(dt_bins)
}
