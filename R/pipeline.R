#' MoCaSeq pipeline metadata
#'
#' Metadata on MoCaSeq pipeline, including wich samples types can be processed,
#' which tools are available, etc.

SAMPLE_TYPES <- c("Tumor", "matched", "Normal")

NUCLEOTIDE_VARIANT_TOOLS <- c("Mutect2", "Strelka")

COPY_NUMBER_CALLERS <- c("CNVKit", "Copywriter", "HMMCopy")

MOCASEQ_TOOLS <- c(NUCLEOTIDE_VARIANT_TOOLS, COPY_NUMBER_CALLERS, "LOH")
