#' Collect the number of multiple-born (MB) species
#' @inheritParams default_params_doc
#' @return a dataframe with folder and number of multiple-born (MB) species
#' @author Richel J.C. Bilderbeek, Giovanni Laudanno
#' @export
collect_n_mb_species <- function(
  project_folder_name = get_razzo_path("razzo_project")
) {
  razzo::check_project_folder_name(project_folder_name) # nolint razzo function

  # Obtain all the tree filenames, as stored in Newick format
  true_tree_filenames <- list.files(
    path = project_folder_name,
    pattern = "^mbd\\.tree$",
    full.names = TRUE,
    recursive = TRUE
  )

  n_trees <- length(true_tree_filenames)
  n_mb_species <- rep(NA, n_trees)
  f_mb_species <- rep(NA, n_trees)
  for (i in seq_along(true_tree_filenames)) {
    tree <- ape::read.tree(true_tree_filenames[[i]])
    brts <- sort(ape::branching.times(tree), decreasing = TRUE)

    # 'mbd::count_n_mb_events' is a misnomer: is counts the
    # number of multiple-born species
    this_n_mb_species <- mbd::count_n_mb_events(brts)

    n_mb_species[i] <- this_n_mb_species
    f_mb_species[i] <- this_n_mb_species / ape::Ntip(tree)
  }

  # Issue 279, Issue #279
  # Should give:
  #   data/0.2-0.15-1-0.1/1                                                     # nolint this is no commented code
  #   data/0.2-0.15-1-0.1/2                                                     # nolint this is no commented code
  folder_names <- razzo::get_data_paths(project_folder_name, full_names = FALSE)

  df <- data.frame(
    folder = folder_names,
    n_mb_species = n_mb_species,
    f_mb_species = f_mb_species,
    stringsAsFactors = FALSE
  )

  assertive::assert_all_are_whole_numbers(df$n_mb_species)
  assertive::assert_is_numeric(df$f_mb_species)
  testit::assert(all(df$f_mb_species >= 0.0))
  testit::assert(all(df$f_mb_species <= 1.0))

  df
}
