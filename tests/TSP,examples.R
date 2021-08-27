testsets <- strsplit(Sys.getenv("_R_CHECK_TESTSETS_"), split = "[, ]")[[1]]
print(testsets)
if (length(testsets) == 0 || "TSP" %in% testsets) {
  source("incl/start.R")
  path <- system.file("tests2", package = "doFuture.tests.extra")
  pathname <- file.path(path, "TSP", "examples.R")
  source(pathname, echo = TRUE)
  source("incl/end.R")
}
rm(list = "testsets")
