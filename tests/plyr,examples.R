testsets <- strsplit(Sys.getenv("_R_CHECK_TESTSETS_"), split = "[, ]")[[1]]
print(testsets)
if (length(testsets) == 0 || "plyr" %in% testsets) {
  source("incl/start.R")
  
  ## Avoid going over 4GB-log size limit on Travis CI
  if (Sys.getenv("TRAVIS") == "true") {
    options(doFuture.debug = FALSE, future.debug = FALSE)
  }

  plyr_examples()
  
  source("incl/end.R")
}
rm(list = "testsets")
