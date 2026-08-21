test_that("get_mocaseq_cnv_file resolves paths correctly for matched sample", {
  sample_id <- "SAMPLE_042_TUMOR"

  # copy number segment files
  result_type <- "segments"
  expect_equal(
    get_mocaseq_cnv_file(
      sample_id,
      "matched",
      "matched",
      "HMMCopy",
      result_type
    ),
    paste0(sample_id, ".HMMCopy.20000.segments.txt")
  )

  expect_equal(
    get_mocaseq_cnv_file(
      sample_id,
      "matched",
      "matched",
      "Copywriter",
      result_type
    ),
    paste0(sample_id, ".Copywriter.segments.Mode.txt")
  )

  expect_equal(
    get_mocaseq_cnv_file(sample_id, "matched", "Tumor", "CNVKit", result_type),
    file.path("matched", paste0(sample_id, ".Tumor", ".cns"))
  )

  expect_error(
    get_mocaseq_cnv_file(sample_id, "matched", "foo", "Copywriter", result_type)
  )

  # copy number ratio files
  result_type <- "ratios"
  expect_equal(
    get_mocaseq_cnv_file(
      sample_id,
      "matched",
      "matched",
      "HMMCopy",
      result_type,
      seg_size = 1000
    ),
    paste0(sample_id, ".HMMCopy.1000.log2RR.txt")
  )

  expect_equal(
    get_mocaseq_cnv_file(
      sample_id,
      "matched",
      "Normal",
      "Copywriter",
      result_type
    ),
    paste0(sample_id, ".Copywriter.log2RR.Mode.txt")
  )

  expect_equal(
    get_mocaseq_cnv_file(
      sample_id,
      "matched",
      "matched",
      "CNVKit",
      result_type
    ),
    file.path("matched", paste0(sample_id, ".cnr"))
  )

  expect_error(
    get_mocaseq_cnv_file(sample_id, "foo", "matched", "CNVKit", result_type)
  )
})

test_that("get_mocaseq_cnv_file resolves paths correctly for single sample", {
  sample_id <- "SAMPLE_042_TUMOR"

  # copy number segment files
  result_type <- "segments"
  expect_equal(
    get_mocaseq_cnv_file(sample_id, "single", "Tumor", "HMMCopy", result_type),
    paste0(sample_id, ".HMMCopy.20000.segments.txt")
  )

  expect_equal(
    get_mocaseq_cnv_file(
      sample_id,
      "single",
      "Tumor",
      "Copywriter",
      result_type
    ),
    paste0(sample_id, ".Copywriter.segments.Mode.txt")
  )

  expect_equal(
    get_mocaseq_cnv_file(sample_id, "single", "Tumor", "CNVKit", result_type),
    file.path("single", paste0(sample_id, ".Tumor", ".cns"))
  )

  # copy number ratio files
  result_type <- "ratios"
  expect_equal(
    get_mocaseq_cnv_file(
      sample_id,
      "single",
      "Tumor",
      "HMMCopy",
      result_type,
      seg_size = 1000
    ),
    paste0(sample_id, ".HMMCopy.1000.log2RR.txt")
  )

  expect_equal(
    get_mocaseq_cnv_file(
      sample_id,
      "single",
      "Tumor",
      "Copywriter",
      result_type
    ),
    paste0(sample_id, ".Copywriter.log2RR.Mode.txt")
  )

  expect_equal(
    get_mocaseq_cnv_file(sample_id, "single", "Tumor", "CNVKit", result_type),
    file.path("single", paste0(sample_id, ".Tumor", ".cnr"))
  )

  expect_error(
    get_mocaseq_cnv_file(sample_id, "single", "foo", "CNVKit", result_type)
  )

  expect_error(
    get_mocaseq_cnv_file(sample_id, "foo", "Tumor", "Copywriter", result_type)
  )
})
