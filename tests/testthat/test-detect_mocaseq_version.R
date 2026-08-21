test_that("detect_mocaseq_version works for bash matched", {
  expect_equal(
    detect_mocaseq_version("data/dummy_bash_matched/results"),
    "bash"
  )
})

test_that("detect_mocaseq_version works for bash single", {
  expect_equal(
    detect_mocaseq_version("data/dummy_bash_single/results"),
    "bash"
  )
})
