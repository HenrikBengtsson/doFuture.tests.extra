testsets <- strsplit(Sys.getenv("_R_CHECK_TESTSETS_"), split = "[, ]")[[1]]
print(testsets)
if (length(testsets) == 0 || "foreach" %in% testsets) {
  source("incl/start.R")
  foreach_examples()
  source("incl/end.R")
}
rm(list = "testsets")
