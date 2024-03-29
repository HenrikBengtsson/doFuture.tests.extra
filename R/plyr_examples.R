#' @importFrom utils assignInNamespace getFromNamespace
plyr_tweak_API <- local({
  tweaked <- FALSE

  ## To please R CMD check
  assign_in_namespace <- assignInNamespace

  function() {
    ## Already done?
    if (tweaked) return()
    
    ns <- getNamespace("plyr")
  
    vars <- ls(envir = ns, all.names = TRUE)
    for (var in vars) {
      if (!exists(var, mode = "function", envir = ns)) next
      fcn <- get(var, mode = "function", envir = ns)
      fmls <- formals(fcn)
      if (!".parallel" %in% names(fmls)) next
      formals(fcn)$.parallel <- TRUE
      message(" - plyr function tweaked: ", var)
      assign_in_namespace(var, fcn, ns = ns)
    }
  
    setup_parallel <- getFromNamespace("setup_parallel", ns = ns)
    body(setup_parallel) <- body(setup_parallel)[-3]
    assign_in_namespace("setup_parallel", setup_parallel, ns = ns)
  }
})


#' Run All Examples of the 'plyr' Package via Futureverse
#'
#' @importFrom utils assignInNamespace getFromNamespace
#' @export
plyr_examples <- function() {
  pkg <- "plyr"
  require(pkg, character.only=TRUE) || stop("Package not installed: ", sQuote(pkg))
  oopts <- options(warnPartialMatchArgs = FALSE, warn = 1L,
                   digits = 3L, mc.cores = 2L)
  on.exit(options(oopts))                   
  
  plyr_tweak_API()
  
  ## Exclude a few tests that takes very long time to run:
  ## (1) example(raply) runs 100's of tasks that each parallelizes only few
  ##     subtasks. Doing so using batchtools_local futures will take quite
  ##     some time, because of the overhead of creating batchtools jobs.
  excl <- "raply"
  ## (2) example(rdply) is as above (but only over 20 iterations).
  excl <- c(excl, "rdply")
  ## (3) Takes 45+ seconds each
  excl <- c(excl, "aaply", "quoted")
  ## (4) Platform specific
  if (.Platform$OS.type != "windows") {
    excl <- c(excl, "progress_win")
  }
  if (.Platform$OS.type != "unix") {
    excl <- c(excl, "progress_tk")
  }
  options("doFuture.tests.topics.ignore" = excl)
  
  subset <- as.integer(Sys.getenv("R_CHECK_SUBSET_"))
  topics <- test_topics(pkg, subset = subset, max_subset = 3)
  
  ## See example(topic, package = "plyr") for why 'run.dontrun' must be FALSE
  excl_dontrun <- c("failwith", "here")
  
  ## Exclude because it requires Tk, which is not available on Travis CI
  if (!capabilities("tcltk") || is.na(Sys.getenv("DISPLAY", NA_character_)) || requireNamespace("tcltk")) {
    excl_dontrun <- c(excl_dontrun, "create_progress_bar", "progress_tk")
  }
  
  mprintf("*** doFuture() - all %s examples ...", pkg)
  
  for (strategy in test_strategies()) {
    mprintf("- plan('%s') ...", strategy)
  
    for (ii in seq_along(topics)) {
      topic <- topics[ii]
      run.dontrun <- !is.element(topic, excl_dontrun)
      
      mprintf("- #%d of %d example('%s', package = '%s', run.dontrun = %s) using plan(%s) ...", ii, length(topics), topic, pkg, run.dontrun, strategy) #nolint
      registerDoFuture()
      plan(strategy)
      dt <- run_example(topic = topic, package = pkg, run.dontrun = run.dontrun, local = TRUE)
      mprintf("- #%d of %d example('%s', package = '%s', run.dontrun = %s) using plan(%s) ... DONE (%s)", ii, length(topics), topic, pkg, run.dontrun, strategy, dt) #nolint
    } ## for (ii ...)
    
    mprintf("- plan('%s') ... DONE", strategy)
  } ## for (strategy ...)
  
  mprintf("*** doFuture() - all %s examples ... DONE", pkg)
}
