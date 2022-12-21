#' Run All Examples of the 'foreach' Package via Futureverse
#'
#' @export
foreach_examples <- function() {
  pkg <- "foreach"
  require(pkg, character.only=TRUE) || stop("Package not installed: ", sQuote(pkg))
  oopts <- options(warnPartialMatchArgs = FALSE, warn = 1L,
                   digits = 3L, mc.cores = 2L)
  on.exit(options(oopts))                   
  
  mprintf("*** doFuture() - all %s examples ...", pkg)
  
  for (strategy in test_strategies()) {
    mprintf("- plan('%s') ...", strategy)
    run_examples(pkg, strategy = strategy, run.dontrun = TRUE)
    mprintf("- plan('%s') ... DONE", strategy)
  } ## for (strategy ...)
  
  mprintf("*** doFuture() - all %s examples ... DONE", pkg)
}
