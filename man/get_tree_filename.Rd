% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_razzo_filenames.R
\name{get_tree_filename}
\alias{get_tree_filename}
\title{Get tree filename}
\usage{
get_tree_filename(folder_name, tree_type)
}
\arguments{
\item{folder_name}{name of the main folder}

\item{tree_type}{can be 'true' or 'twin'}
}
\description{
Get tree filename
}
\examples{
library(testthat)

expect_equal(
  get_tree_filename(folder_name = "", tree_type = "true"),
  "/mbd.tree"
)
expect_equal(
  get_tree_filename(folder_name = "", tree_type = "twin"),
  "/mbd_twin.tree"
)
}
\author{
Giovanni Laudanno, Richel J.C. Bilderbeek
}
