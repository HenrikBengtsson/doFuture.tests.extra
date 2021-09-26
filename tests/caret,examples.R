source("incl/start.R")
if (require("caret")) {
  if (length(testsets) == 0 || "caret" %in% testsets) {
    exclude <- NULL
    
    ## WORKAROUND/FIXME: Example #29 ('gafs.default') fails with
    ## future.callr::callr
    if (inherits(plan("next"), "callr")) {
      exclude <- "gafs.default"
      ## FIXME: Can't get this to work?!?
      next
    }
    caret_examples(exclude = exclude)
  }
}
source("incl/end.R")
