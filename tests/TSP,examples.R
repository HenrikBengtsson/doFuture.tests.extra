testsets <- strsplit(Sys.getenv("_R_CHECK_TESTSETS_"), split = "[, ]")[[1]]
print(testsets)
if (length(testsets) == 0 || "TSP" %in% testsets) {
  source("incl/start.R")
  TSP_examples()
  source("incl/end.R")
}
rm(list = "testsets")
