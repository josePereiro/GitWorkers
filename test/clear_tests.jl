# Delete test repo
rm(REPOROOT, recursive = true, force = true)
rm(NOT_REPOROOT, recursive = true, force = true)
println("Test files deleted")