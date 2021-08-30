source("incl/start.R")
if (require("caret")) {
  if (length(testsets) == 0 || "caret" %in% testsets) {
    caret_examples()
  }
}
source("incl/end.R")
