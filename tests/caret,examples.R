testsets <- strsplit(Sys.getenv("_R_CHECK_TESTSETS_"), split = "[, ]")[[1]]
print(testsets)
if (length(testsets) == 0 || "caret" %in% testsets) {
  source("incl/start.R")
  caret_examples()
  source("incl/end.R")
}
rm(list = "testsets")
