#' Run All Examples of the 'glmnet' Package via Futureverse
#'
#' @export
glmnet_examples <- function() {
  pkg <- "glmnet"
  require(pkg, character.only=TRUE) || stop("Package not installed: ", sQuote(pkg))
  oopts <- options(warnPartialMatchArgs = FALSE, warn = 1L,
                   digits = 3L, mc.cores = 2L)
  on.exit(options(oopts))                   
  
  ## WORKAROUND: Some of the glmnet examples tries to use more parallel cores
  ## than accepted by R CMD check, i.e. more than two.  This causes an error
  ## in itself.  Also, we don't care about testing with doMC, so we can
  ## simply set up a dummy registerDoMC() here.
  registerDoMC <- function(...) NULL
  
  ## Skip example("cv.glmnet", package = "glmnet", run.dontrun = TRUE) because
  ## it produces an error also with 'R --vanilla';
  ##   Error in cbind2(1, newx) %*% nbeta : 
  ##     Cholmod error 'X and/or Y have wrong dimensions' at file
  ##     ../MatrixOps/cholmod_sdmult.c, line 90
  ## /HB 2020-01-09
  excl_topics <- "cv.glmnet"
  options(doFuture.tests.topics.ignore = excl_topics)
  
  mprintf("*** doFuture() - all %s examples ...", pkg)
  
  for (strategy in test_strategies()) {
    mprintf("- plan('%s') ...", strategy)
    run_examples(pkg, strategy = strategy, run.dontrun = TRUE)
    mprintf("- plan('%s') ... DONE", strategy)
  } ## for (strategy ...)
  
  mprintf("*** doFuture() - all %s examples ... DONE", pkg)
}
