loadNamespace("doFuture.tests.extra")

## Record original state
ovars <- ls()
oopts <- options(warn = 1L,
                 mc.cores = 2L,
                 future.debug = TRUE,
                 doFuture.debug = TRUE)
oplan <- future::plan()

future::plan(future::sequential)
doFuture::registerDoFuture()

test_strategies <- doFuture.tests.extra:::test_strategies

mdebug <- doFuture:::mdebug
mprint <- doFuture:::mprint
mprintf <- doFuture.tests.extra:::mprintf
mstr <- doFuture:::mstr

testsets <- strsplit(Sys.getenv("_R_CHECK_TESTSETS_"), split = "[, ]")[[1]]
