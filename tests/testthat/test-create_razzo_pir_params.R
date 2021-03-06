test_that("use", {

  if (rappdirs::app_dir()$os == "win") {
    skip("This can only run on Linux.")
  }

  ##############################################################################
  # FALSE FALSE
  ##############################################################################
  pir_params <- create_razzo_pir_params(
    has_candidates = FALSE,
    has_twinning = FALSE
  )
  expect_equal(length(pir_params$experiments), 1)
  expect_equal(
    pir_params$experiments[[1]]$inference_conditions$model_type,
    "generative"
  )
  expect_true(beautier::is_one_na(pir_params$twinning_params))

  ##############################################################################
  # FALSE TRUE
  ##############################################################################
  pir_params <- create_razzo_pir_params(
    has_candidates = FALSE,
    has_twinning = TRUE
  )
  expect_equal(length(pir_params$experiments), 1)
  expect_equal(
    pir_params$experiments[[1]]$inference_conditions$model_type,
    "generative"
  )
  expect_false(beautier::is_one_na(pir_params$twinning_params))

  ##############################################################################
  # TRUE FALSE
  ##############################################################################
  pir_params <- create_razzo_pir_params(
    has_candidates = TRUE,
    has_twinning = FALSE
  )
  expect_true(length(pir_params$experiments) > 1)
  expect_equal(
    pir_params$experiments[[1]]$inference_conditions$model_type,
    "generative"
  )
  expect_equal(
    pir_params$experiments[[2]]$inference_conditions$model_type,
    "candidate"
  )
  expect_true(beautier::is_one_na(pir_params$twinning_params))

  ##############################################################################
  # TRUE TRUE
  ##############################################################################
  pir_params <- create_razzo_pir_params(
    has_candidates = TRUE,
    has_twinning = TRUE
  )
  expect_true(length(pir_params$experiments) > 1)
  expect_equal(
    pir_params$experiments[[1]]$inference_conditions$model_type,
    "generative"
  )
  expect_equal(
    pir_params$experiments[[2]]$inference_conditions$model_type,
    "candidate"
  )
  expect_false(beautier::is_one_na(pir_params$twinning_params))
})

test_that("matches article", {

  if (rappdirs::app_dir()$os == "win") {
    skip("This can only run on Linux.")
  }

  # Issue 242, Isssue #242
  pir_params <- create_razzo_pir_params(
    has_candidates = TRUE,
    has_twinning = TRUE
  )

  ##############################################################################
  # pir_params$twinning_params
  # checked at 'create_razzo_twinning_params
  ##############################################################################
  # pir_params$alignment_params
  ##############################################################################
  expect_equal(
    pirouette::create_blocked_dna(length = get_razzo_dna_alignment_length()),
    pir_params$alignment_params$root_sequence
  )
  if (1 == 2) {
    # Cannot read the mutation rates that is already partially evaluated in
    # the function
    #
    # These all fail to read the mutation rate filled in in the function
    formals(pir_params$alignment_params$sim_tral_fun)
    formalArgs(pir_params$alignment_params$sim_tral_fun)
    args(pir_params$alignment_params$sim_tral_fun)
    alist(pir_params$alignment_params$sim_tral_fun)
    body(pir_params$alignment_params$sim_tral_fun)
    body(pir_params$alignment_params$sim_tral_fun)
    class(pir_params$alignment_params$sim_tral_fun)
    attributes(pir_params$alignment_params$sim_tral_fun)

    expect_equal(
      get_razzo_mutation_rate(),
      pir_params$alignment_params$sim_tral_fun$mutation_rate
    )
  }
  if (1 == 2) {
    expect_equal(
      pir_params$alignment_params$sim_tral_fun$site_model$name,
      "JC69"
    )
  }

  ##############################################################################
  # pir_params$experiments
  ##############################################################################
  # First and generative experiment
  gen_exp <- pir_params$experiments[[1]]
  # --------------------
  # Inference conditions
  # --------------------
  expect_equal(gen_exp$inference_conditions$model_type, "generative")
  expect_equal(gen_exp$inference_conditions$run_if, "always")
  # Shouldn't we measure the evidence for the generative model?
  expect_equal(gen_exp$inference_conditions$do_measure_evidence, TRUE)
  # --------------------
  # Inference model
  # --------------------
  expect_equal(gen_exp$inference_model$site_model$name, "JC69")
  expect_equal(gen_exp$inference_model$clock_model$name, "strict")
  expect_equal(gen_exp$inference_model$tree_prior$name, "birth_death")
  expect_equal(
    gen_exp$inference_model$mrca_prior$mrca_distr$name,
    "normal"
  )
  expect_equal(
    gen_exp$inference_model$mrca_prior$mrca_distr$mean$value,
    get_razzo_crown_age()
  )
  expect_equal(
    gen_exp$inference_model$mrca_prior$mrca_distr$sigma$value,
    0.0001
  )
  expect_equal(
    gen_exp$inference_model$mcmc$chain_length,
    get_razzo_mcmc_chain_length()
  )
  expect_equal(
    gen_exp$inference_model$mcmc$store_every,
    get_razzo_mcmc_store_every()
  )
  expect_equal(
    gen_exp$est_evidence_mcmc$chain_length,
    get_razzo_mcmc_chain_length()
  )
  # gen_exp$est_evidence_mcmc
  expect_equal(
    gen_exp$est_evidence_mcmc$chain_length,
    create_razzo_nested_sampling_mcmc()$chain_length
  )
  expect_equal(
    gen_exp$est_evidence_mcmc$store_every,
    create_razzo_nested_sampling_mcmc()$store_every
  )
  expect_equal(
    gen_exp$est_evidence_mcmc$epsilon,
    create_razzo_nested_sampling_mcmc()$epsilon
  )
  expect_equal(
    gen_exp$est_evidence_mcmc$particle_count,
    create_razzo_nested_sampling_mcmc()$particle_count
  )
  expect_equal(
    gen_exp$est_evidence_mcmc$sub_chain_length,
    create_razzo_nested_sampling_mcmc()$sub_chain_length
  )
  # --------------------
  # beast2_options
  # --------------------
  # gen_exp$beast2_options$rng_seed must match MBD RNG seed
  # --------------------
  # est_evidence_mcmc
  # --------------------
  gen_exp$est_evidence_mcmc

  ##############################################################################
  # pir_params$error_measure_params
  ##############################################################################

  # Etcetera ...
})

test_that("follows naming convention", {

  if (rappdirs::app_dir()$os == "win") {
    skip("This can only run on Linux.")
  }

  # Issue 242, Isssue #242
  folder_name <- peregrine::get_pff_tempfile()
  pir_params <- create_razzo_pir_params(
    folder_name = folder_name,
    has_candidates = TRUE,
    has_twinning = TRUE
  )

  ##############################################################################
  # pir_params$twinning_params
  ##############################################################################
  expect_equal(
    pir_params$twinning_params$twin_tree_filename,
    file.path(folder_name, "mbd_twin.tree")
  )
  expect_equal(
    pir_params$twinning_params$twin_alignment_filename,
    file.path(folder_name, "mbd_twin.fasta")
  )
  expect_equal(
    pir_params$twinning_params$twin_evidence_filename,
    file.path(folder_name, "mbd_marg_lik_twin.csv")
  )

  ##############################################################################
  # pir_params$alignment_params
  ##############################################################################
  expect_equal(
    pir_params$alignment_params$fasta_filename,
    file.path(folder_name, "mbd.fasta")
  )

  ##############################################################################
  # pir_params$experiments
  ##############################################################################


  ##############################################################################
  # pir_params$error_measure_params
  ##############################################################################

  # Etcetera ...
})
