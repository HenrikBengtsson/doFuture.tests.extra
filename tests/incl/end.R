## Restore original state
options(oopts)
future::plan(oplan)
foreach::registerDoSEQ()

rm(list = "testsets")
rm(list = c(setdiff(ls(), ovars)))

print(sessionInfo())

