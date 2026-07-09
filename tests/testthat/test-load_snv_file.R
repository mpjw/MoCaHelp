test_that("loading SNV data from Mutect2 (bash version) works", {
  dt_snv <- load_snv_file(
    snv_file = "data/test/Dummy.Mutect2.bash.txt",
    pipeline_version = "bash"
  )
  expect_equal(colnames(dt_snv), MUTECT2_COLUMN_NAMES_STANDARD)
})

test_that("loading SNV data from Mutect2 (nextflow version) works", {
  dt_snv <- load_snv_file(
    snv_file = "data/test/Dummy.Mutect2.nextflow.txt",
    pipeline_version = "nextflow"
  )
  expect_equal(colnames(dt_snv), MUTECT2_COLUMN_NAMES_STANDARD)
})
