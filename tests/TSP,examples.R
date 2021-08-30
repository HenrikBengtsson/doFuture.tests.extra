source("incl/start.R")
if (require("plyr")) {
  if (length(testsets) == 0 || "TSP" %in% testsets) {
    TSP_examples()
  }
}
source("incl/end.R")
