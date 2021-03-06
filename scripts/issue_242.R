# Solves the following question,
# from rsetienne:
#
# > Kun je een schatting geven van de fout in de marginal loglikelihood?
#
#
#
# This issue matured into the script at
#
# https://github.com/richelbilderbeek/razzo_project/blob/richel/scripts/83_create_fig_marg_liks.sh
#

library(dplyr)

all_marg_liks_filenames <- list.files(
  path = "/home/richel/data",
  pattern = "marg_liks.csv",
  recursive = TRUE,
  full.names = TRUE
)
all_marg_liks_filenames

marg_liks_filenames <- purrr::discard(
    stringr::str_match(
    string = all_marg_liks_filenames,
    pattern = ".*/razzo_project_.*"
  )[,1],
  is.na
)
marg_liks_filenames

# Extract the dates in ISO format YYYYMMDD
dates <- stringr::str_match(
  string = marg_liks_filenames,
  pattern = "[:digit:]{8}"
)[,1]
dates

marg_liks_filename <- marg_liks_filenames[4]
df <- read.csv(marg_liks_filename)
df$seed <- stringr::str_match(string = df$folder, pattern = "/([0-9]{1,2})$")[, 2]




names(df)
nrow(df)

testit::assert(is.factor(df$folder))
testit::assert(is.factor(df$tree))
testit::assert(is.factor(df$site_model))
testit::assert(is.factor(df$clock_model))
testit::assert(is.factor(df$tree_prior))

library(ggplot2)

df$inference_model <- fct_cross(fct_cross(df$site_model, df$clock_model), df$tree_prior)

twin_site_model_name <- create_razzo_alignment_params(folder_name = "")$site_model$name
twin_clock_model_name <- create_razzo_alignment_params(folder_name = "")$clock_model$name
twin_tree_prior_name <- create_razzo_twinning_params(folder_name = "")$twin_model
twin_generative_model_name <- paste(
  twin_site_model_name,
  twin_clock_model_name,
  twin_tree_prior_name,
  sep = ", "
)
twin_generative_model_name

ggplot(df, aes(x = tree, y = marg_log_lik, col = inference_model)) +
  geom_point(
    position = position_dodge(0.2),
    size = 0.2
  ) +
  geom_errorbar(
    aes(
      ymin = marg_log_lik - marg_log_lik_sd,
      ymax = marg_log_lik + marg_log_lik_sd
    ),
    width = 0.4,
    position = position_dodge(0.2)
  ) +
  facet_wrap(seed ~ tree, scales = "free", ncol = 12) +
  theme(
    #axis.title.y=element_blank(),
    axis.text.y=element_blank(),
    axis.ticks.y=element_blank()
  ) +
  labs(
    title = "Marginal likelihoods estimates and their standard errors",
    subtitle = paste0("Do twin models really prefer the true model of ", twin_generative_model_name, "?"),
    caption = "Error bars denote standard deviation in estimation",
    y = "Marginal log likelihood (higher means the likelier model)"
  ) +
  ggsave("~/issue_242.png", width = 10, height = 10)



library(forcats)
  geom_errorbar()

# true/twin on horizontal column
# folder on vertical rows

# Collect all data frames
for (i in seq_along(marg_liks_filenames)) {
  marg_liks_filename <- marg_liks_filenames[i]
  this_df <- read.csv(marg_liks_filename) %>% select(marg_liks)
  this_df$date <- dates[i]
  this_df$index <- seq(1, nrow(this_df))
  df <- rbind(df, this_df)
}
head(df)

df$data <- as.factor(df$date)
df$index <- as.factor(df$index)

library(ggplot2)
library(dplyr)
library(plyr)

# As a figure
ggplot(data = df, aes(x = marg_liks)) + geom_histogram(binwidth = 10) +
  ggplot2::facet_grid(date ~ .) +
  ggplot2::geom_vline(data = ddply(df, "date", summarize, median_marg_liks = median(marg_liks)), aes(xintercept = median_marg_liks), col = "red") +
  ggplot2::geom_vline(data = ddply(df, "date", summarize, mean_marg_liks = mean(marg_liks)), aes(xintercept = mean_marg_liks), col = "blue") +
  ggtitle("marg_liks per date, median = red, mean = blue") +
  ggsave("~/issue_260.png", width = 7, height = 7)


# As a table
knitr::kable(
  ddply(df, "date", summarize, median_marg_liks = median(marg_liks), mean_marg_liks = mean(marg_liks))
)
