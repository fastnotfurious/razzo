context("collect_esses")

test_that("use", {

  df <- collect_esses(
    project_folder_name = get_path("razzo_project")
  )

  # Experimental parameters that vary
  expect_true("lambda" %in% names(df))
  expect_true("mu" %in% names(df))
  expect_true("nu" %in% names(df))
  expect_true("q" %in% names(df))
  expect_true("seed" %in% names(df))
  expect_true("site_model" %in% names(df))
  expect_true("clock_model" %in% names(df))

  # gen_model is the generative model,
  # can be 'mbd' (the MBD tree)
  # or 'bd' (for the twin BD tree)
  expect_true("gen_model" %in% names(df))

  # I (@richelbilderbeek) suggest to take the ESS of the likelihood,
  # and that one only. We'll see if that idea changes in the future.
  expect_true("ess_likelihood" %in% names(df))

  # Data must be tidy
  expect_true(is.factor(df$gen_model))
  expect_true(is.factor(df$clock_model))
  expect_true(is.factor(df$site_model))

})

test_that("abuse", {
  expect_error(
    collect_esses(
      project_folder_name = "nonsense"
    ),
    "'project_folder_name' must end with 'razzo_project'"
  )
})