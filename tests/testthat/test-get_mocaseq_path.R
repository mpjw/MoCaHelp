test_that("get_mocaseq_path works for LOH", {
  loh_path <- get_mocaseq_path(
    sample_name = "ASHPC_0010_Pa_P",
    sample_type = "matched",
    tool_name = "LOH",
    base_path = "/storage/path",
    ignore_not_existing = TRUE
  )

  expect_equal(
    loh_path,
    "/storage/path/ASHPC_0010_Pa_P/results/LOH/ASHPC_0010_Pa_P.VariantsForLOH.txt"
  )
})
