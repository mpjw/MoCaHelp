test_that("detect_sample_mode works for bash matched", {
  expect_equal(
    detect_sample_mode("data/dummy_bash_matched/results"),
    "matched"
  )
})

test_that("detect_sample_mode works for bash single", {
  expect_equal(
    detect_sample_mode("data/dummy_bash_single/results"),
    "single"
  )
})

# test_that("detect_sample_mode works for nextflow matched", {
#   expect_equal(
#     detect_sample_mode("data/dummy_sample/results"),
#     "matched"
#   )
# })

# test_that("detect_sample_mode works for nextflow single", {
#   expect_equal(
#     detect_sample_mode("data/dummy_sample/results"),
#     "single"
#   )
# })
