source("incl/start.R")
if (length(testsets) == 0 || "foreach" %in% testsets) {
  foreach_examples()
}
source("incl/end.R")
