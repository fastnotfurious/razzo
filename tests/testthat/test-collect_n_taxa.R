context("test-collect_n_taxa")

test_that("use", {

  if (1 == 2) {
    # Run the experiment if you can and need to
    for (file in list.files(get_razzo_path("razzo_project"), recursive = TRUE, pattern = "parameters\\.RDa")) {
      run_razzo(open_parameters_file(file))
    }
  }
  df <- collect_n_taxa(
    project_folder_name = get_razzo_path("razzo_project")
  )

  # Experimental parameters that vary
  expect_true("lambda" %in% names(df))
  expect_true("mu" %in% names(df))
  expect_true("nu" %in% names(df))
  expect_true("q" %in% names(df))
  expect_true("seed" %in% names(df))
  expect_true("site_model" %in% names(df))
  expect_true("clock_model" %in% names(df))

  # The number of taxa
  expect_true("n_taxa" %in% names(df))
  expect_true(is.numeric(df$n_taxa))

  # Data must be tidy
  expect_true(is.factor(df$clock_model))
  expect_true(is.factor(df$site_model))

  # Rows must be unique
  expect_equal(nrow(unique(df)), nrow(df))

  # As true and twin trees have the same number of taxa, no need
  # to have a 'tree' (with values 'true' or 'twin') column
  expect_false("tree" %in% names(df))

  # As all trees (true, twin, posterior) have an equal amount of tips
  n_rows_expected <- length(
    list.files(
      get_razzo_path("razzo_project"),
      recursive = TRUE,
      pattern = "parameters\\.RDa"
    )
  )
  expect_equal(nrow(df), n_rows_expected)
})