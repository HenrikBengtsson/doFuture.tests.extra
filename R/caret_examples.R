#' @export
caret_examples <- function(exclude = NULL) {
  pkg <- "caret"
  require(pkg, character.only=TRUE) || stop("Package not installed: ", sQuote(pkg))
  oopts <- options(warnPartialMatchArgs = FALSE, warn = 1L,
                   digits = 3L, mc.cores = 2L)
  on.exit(options(oopts))                   
  
  excl <- c(
    "featurePlot",
    ## Non-functional example, because they depend on
    ## an object that is not available/not loaded.
    "dotplot.diff.resamples",
    "xyplot.resamples",
    "prcomp.resamples",
    "diff.resamples"
  )

  if (getRversion() >= "4.2.0") {
    excl <- c(excl, "summary.bagEarth")
  }

  excl_dontrun <- c(
    ## Non-functional example(run.dontrun = TRUE)
    ## (gives a parsing error)
    "gafs_initial",
    "safs_initial",
    ## Other non-functional/broken example(run.dontrun = TRUE)
    "sensitivity",
    "plotClassProbs",
    "plotObsVsPred",
    "rfeControl",
    "sbf",
    ## Very very slow
    "plsda",
    "rfe",
    ## _R_CHECK_LENGTH_1_LOGIC2_ bugs
    "train"
  )
  
  if (!grepl("foreach", doFuture:::globalsAs())) {
    ## example("avNNet", run.dontrun = TRUE) only works with a more liberal
    ## identification method for globals than 'future', e.g. 'foreach'
    ## See https://github.com/HenrikBengtsson/doFuture/issues/17
    excl_dontrun <- c(excl_dontrun, "avNNet")
  }
  
  excl <- getOption("doFuture.tests.topics.ignore", excl)
  excl <- c(excl, exclude)
  
  options(doFuture.tests.topics.ignore = excl)
  
  subset <- as.integer(Sys.getenv("R_CHECK_SUBSET_"))
  topics <- test_topics(pkg, subset = subset, max_subset = 4)
  
  mprintf("*** doFuture() - all %s examples ...", pkg)
  
  ## Several examples of 'caret' only works with doSEQ and forked doParallel,
  ## but not cluster doParallel.  Try for instance,
  ##
  ##   library("doParallel")
  ##   registerDoParallel(cl <- makeCluster(2L))
  ##   example("train", package = "caret", run.dontrun = TRUE)
  ##   [...]
  ##   Error in e$fun(obj, substitute(ex), parent.frame(), e$data) : 
  ##     unable to find variable "optimism_boot"
  ##
  ## or equivalently:
  ##
  ##   library("doFuture.tests.extra")
  ##   registerDoFuture()
  ##   plan(multisession, workers = 2L)
  ##   example("train", package = "caret", run.dontrun = TRUE)
  ##
  
  for (strategy in test_strategies()) {
    mprintf("- plan('%s') ...", strategy)
  
    for (ii in seq_along(topics)) {
      topic <- topics[ii]
      ## BUG?: example("calibration", run.dontrun = TRUE) only works
      ## for plan(transparent), but not even plan(sequential).  It gives:
      ## Error in qda.default(x, grouping, ...) : 
      ##     rank deficiency in group Inactive
      ## but it only happens if other examples were ran prior to this example.
      ## There seems to be some stray objects that affects this example.
      ## Leaving it at this for now. /HB 2017-12-19
      run.dontrun <- !is.element(topic, c("calibration", excl_dontrun))
  
      mprintf("- #%d of %d example('%s', package = '%s', run.dontrun = %s) using plan(%s) ...", ii, length(topics), topic, pkg, run.dontrun, strategy) #nolint
      registerDoFuture()
      plan(strategy)
      dt <- run_example(topic = topic, package = pkg, run.dontrun = run.dontrun, local = FALSE)
  
      mprintf("- #%d of %d example('%s', package = '%s', run.dontrun = %s) using plan(%s) ... DONE (%s)", ii, length(topics), topic, pkg, run.dontrun, strategy, dt) #nolint
    } ## for (ii ...)
  
    mprintf("- plan('%s') ... DONE", strategy)
  } ## for (strategy ...)
  
  mprintf("*** doFuture() - all %s examples ... DONE", pkg)
}
