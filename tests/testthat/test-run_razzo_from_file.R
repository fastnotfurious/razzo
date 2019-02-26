context("test-run_razzo_from_file")

test_that("use", {

  if (!beastier::is_on_travis()) return()

  super_folder_name <- tempdir()
  project_folder_name <- file.path(super_folder_name, "razzo_project")
  dir.create(path = project_folder_name, recursive = TRUE, showWarnings = FALSE)
  parameters_filenames <- create_test_parameters_files(project_folder_name)
  # Only run the first
  expect_silent(run_razzo_from_file(parameters_filenames[1]))
})

test_that("abuse", {

  parameters_filename <- "neverland"
  expect_error(
    run_razzo_from_file(
      parameters_filename = parameters_filename
    )
  )
})