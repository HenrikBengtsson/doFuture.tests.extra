source("incl/start.R")
if (require(TSP)) {
  if (length(testsets) == 0 || "TSP" %in% testsets) {
    TSP_examples()
  }
}
source("incl/end.R")
