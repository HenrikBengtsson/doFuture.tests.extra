testsets <- strsplit(Sys.getenv("_R_CHECK_TESTSETS_"), split = "[, ]")[[1]]
print(testsets)
if (length(testsets) == 0 || "NMF" %in% testsets) {
  source("incl/start.R")
  NMF_manual()
  source("incl/end.R")
}
rm(list = "testsets")
