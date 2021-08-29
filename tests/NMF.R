source("incl/start.R")

if (require(NMF, character.only = TRUE)) {
  message("*** NMF w / doFuture ...")

  ## From NMF vignette
  ## run on all workers using the current parallel backend
  data("esGolub", package = "NMF")

  strategies <- future:::supportedStrategies()
  strategies <- setdiff(strategies, "multiprocess")

  res0 <- NULL

  res_truth <- nmf(esGolub, rank = 3L, method = "brunet", nrun = 2L, .opt = "p", seed = 0xBEEF)

  for (strategy in strategies) {
    message(sprintf("- plan('%s') ...", strategy))
    
    registerDoFuture()
    plan(strategy)
  
    res <- nmf(esGolub, rank = 3L, method = "brunet", nrun = 2L, .opt = "p",
               seed = 0xBEEF, .pbackend = NULL)
    str(res)
    stopifnot(all.equal(res, res_truth, check.attributes = FALSE))
    
    mprintf("- plan('%s') ... DONE", strategy)
  } ## for (strategy ...)
  
  message("*** NMF w / doFuture ... DONE")
  
  tests2_step("stop")
}

