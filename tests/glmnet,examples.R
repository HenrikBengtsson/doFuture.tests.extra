source("incl/start.R")
if (require(glmnet)) {
  if (length(testsets) == 0 || "glmnet" %in% testsets) {
    glmnet_examples()
  }
}
source("incl/end.R")
