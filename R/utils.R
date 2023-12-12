mprintf <- function(...) message(sprintf(...))

find_rd_topics <- function(package) {
  path <- find.package(package)
  file <- file.path(path, "help", "aliases.rds")
  topics <- readRDS(file)
  sort(unique(topics))
}


#' Run All Examples of the 'test_topics' Package via Futureverse
#'
#' @param package A package name.
#'
#' @param subset An integer index.
#'
#' @param max_subset An integer or NULL.
#'
#' @return
#' Return Rd topics.
#'
#' @export
test_topics <- local({
  topics <- NULL
  function(package, subset = NA_integer_, max_subset = NULL) {
    if (is.null(topics)) {
      topics <- getOption("doFuture.tests.topics", find_rd_topics(package))
    
      ## Some examples may give errors when used with futures
      excl <- getOption("doFuture.tests.topics.ignore", NULL)
      topics <- setdiff(topics, excl)
    }
    subset <- as.integer(subset)
    if (!is.na(subset)) {
      stopifnot(is.numeric(subset), is.numeric(max_subset))
      n <- length(topics)
      topics <- topics[split(1:n, sort(1:n %% max_subset))[[subset]]]
    }
    topics
  }
})


#' Run one package example
#'
#' @inheritParams utils::example
#'
#' @param envir The environment from which variables created by the
#' examples should be removed at the end.
#'
#' @return
#' Invisibly, returns the processing time.
#'
#' @seealso
#' [utils::example()] is used to run the select example.
#'
#' @importFrom grDevices graphics.off
#' @importFrom utils example
#' @export
run_example <- function(topic, package, local = FALSE, run.dontrun = TRUE, envir = globalenv()) {
  ovars <- ls(all.names = TRUE, envir = envir)
  on.exit({
    graphics.off()
    vars <- setdiff(ls(all.names = TRUE), c(ovars, "ovars"))
    suppressWarnings(rm(list = vars, envir = envir))
  })
  
  dt <- system.time({
    example(topic = topic, package = package, character.only = TRUE,
            echo = TRUE, ask = FALSE, local = local,
            run.dontrun = run.dontrun)
  })
  
  dt <- dt[1:3]; names(dt) <- c("user", "system", "elapsed")
  dt <- paste(sprintf("%s: %g", names(dt), dt), collapse = ", ")
  message("  Total processing time for example: ", dt)
  
  invisible(dt)
}


#' Run a package's examples for a specific future plan
#'
#' @param package A package name.
#'
#' @param topics One or more Rd topics.
#'
#' @param strategy A future strategy passed to [future::plan()].
#'
#' @param \dots Additional arguments passed to [run_example()].
#'
#' @return
#' Invisibly, returns the processing time.
#'
#' @importFrom doFuture registerDoFuture
#' @importFrom future plan
#' @export
run_examples <- function(package, topics = test_topics(package), strategy, ...) {
  if (length(topics) == 0) return()

  for (ii in seq_along(topics)) {
    topic <- topics[ii]
    mprintf("- #%d of %d example('%s', package = '%s') using plan(%s) ...", ii, length(topics), topic, package, strategy) #nolint
    registerDoFuture()
    plan(strategy)
    dt <- run_example(topic = topic, package = package, ...)
    mprintf("- #%d of %d example('%s', package = '%s') using plan(%s) ... DONE (%s)", ii, length(topics), topic, package, strategy, dt) #nolint
  } ## for (ii ...)
}


#' Get Available Future Strategies
#'
#' @return
#' A character vector of future strategies.
#'
#' @export
test_strategies <- function() {
  strategies <- Sys.getenv("_R_CHECK_FUTURE_STRATEGIES_",
                           "sequential,multisession")
  strategies <- getOption("doFuture.tests.strategies", strategies)
  strategies <- unlist(strsplit(strategies, split = "[, ]"))
  strategies <- strategies[nzchar(strategies)]
  ## Default is to use what's provided by the future package
  if (length(strategies) == 0) strategies <- future:::supportedStrategies()
  if (getOption("future.debug", FALSE)) {
    mprintf("test_strategies(): %s\n",
            paste(sQuote(strategies), collapse = ", "))
  }
  strategies
}
