source("incl/start.R")
options(future.debug = FALSE)
options(doFuture.debug = FALSE)
if (require(caret)) {
  if (length(testsets) == 0 || "caret" %in% testsets) {
    exclude <- NULL
    
    ## WORKAROUND/FIXME: Several examples fail with future.callr::callr
    if ("future.callr::callr" %in% test_strategies()) {
      exclude <- c("gafs.default", "plot.gafs", "panel.lift2", "predict.gafs", "resamples", "resampleSummary", "safs", "trainControl", "twoClassSim", "update.safs")
    }
    caret_examples(exclude = exclude)
  }
}
source("incl/end.R")
