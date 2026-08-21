# MoCaSeq pipeline metadata
#
# Metadata on MoCaSeq pipeline, including wich samples types can be processed,
# which tools are available, etc.

SAMPLE_TYPES <- c("Tumor", "matched", "Normal")

SAMPLE_MODES <- c("single", "matched")

NUCLEOTIDE_VARIANT_TOOLS <- c("Mutect2", "Strelka")

COPY_NUMBER_CALLERS <- c("CNVKit", "Copywriter", "HMMCopy")

MOCASEQ_TOOLS <- c(NUCLEOTIDE_VARIANT_TOOLS, COPY_NUMBER_CALLERS, "LOH")

#' Detect MoCaSeq pipeline version
#'
#' @param results_path Character path to results for a given sample. I.e. this
#' path should end with sample_id/results
#' @return Character 'bash', or 'nextflow' indicating MoCaSeq pipeline version
detect_mocaseq_version <- function(results_path) {
  bash_qc_exists <- dir.exists(file.path(results_path, "QC"))
  matched_files <- Sys.glob(file.path(results_path, "*", "*.matched.*"))
  if (bash_qc_exists || length(matched_files) == 0) {
    "bash"
  } else {
    "nextflow"
  }
}

#' Determine if sample is matched or not
#'
#' @param results_path Character, path to results for a certain sample.
#' @return Chacacter indicating if results are from "matched" healthy-tumor
#' sample pair or "single" only tumor sample. See \code{SAMPLE_MODES}
#' @export
detect_sample_mode <- function(results_path) {
  # assume single, only tumor, sample by default
  sample_mode <- "single"

  if (detect_mocaseq_version(results_path) == "bash") {
    # check QC file for bash version
    qc_report <- grep(
      "report.txt",
      list.files(file.path(results_path, "QC"), full.names = TRUE),
      value = TRUE
    )
    if (file.exists(qc_report)) {
      mode_line <- grep(
        "mode",
        readLines(file(qc_report), n = 25),
        value = TRUE
      )
      if (length(grep("MS", x = mode_line)) > 0) {
        sample_mode <- "matched"
      }
    } else {
      # if there is no QC report in the bash version, somthing went very wrong
      stop(paste0(
        "No QC report in ",
        results_path,
        "! Assuming results are compromized"
      ))
    }
  } else {
    # for nextflow version naive approach to search for files/dirs with Normal
    # or matched in name
    normal_files <- list.files(
      results_path,
      pattern = "Normal",
      recursive = TRUE
    )
    matched_files <- list.files(
      results_path,
      pattern = "matched",
      # include.dirs = TRUE,
      recursive = TRUE
    )
    if (length(normal_files) > 0) {
      if (length(matched_files) > 0) {
        sample_mode <- "matched"
      } else {
        warning(paste0(
          "No matched files in ",
          results_path,
          "! matched MoCaSeq run likely exited prematurely."
        ))
      }
    }
  }

  sample_mode
}


#' Detect CNV caller in MoCaSeq results
#'
#' MoCaSeq employs CNVKit, HMMCopy and Copywriter for calling copy number
#' variations (CNVs). It stores any results under \code{sample_name/results/} in
#' a subfolder with the respective \code{tool_name}. This function exploits this
#' structure by searching all available tools for a CNV caller.
#'
#' @param results_path Character, path to results for a certain sample.
#' @return Character name of CNV caller one of "CNVKit", "HMMCopy" or
#'  "CopyWriter".
#' @export
detect_mocaseq_cnv_caller <- function(results_path) {
  stopifnot(dir.exists(results_path))
  result_tools <- basename(list.dirs(results_path, recursive = FALSE))
  if ("CNVKit" %in% result_tools) {
    "CNVKit"
  } else if ("HMMCopy" %in% result_tools) {
    "HMMCopy"
  } else if ("Copywriter" %in% result_tools) {
    "Copywriter"
  } else {
    stop(paste0(
      "Cannot detect CNV caller from MoCaSeq output! ",
      "No CNV caller found in: ",
      results_path
    ))
  }
}
