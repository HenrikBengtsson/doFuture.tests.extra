source("incl/start.R")
if (require(plyr)) {
  if (length(testsets) == 0 || "plyr" %in% testsets) {
    ## Avoid giant log out (~ 4 GB)
    options(doFuture.debug = FALSE, future.debug = FALSE)
    plyr_examples()
  }
}
source("incl/end.R")
