# Delete test repo
for file in TEST_FILES
    rm(file |> dirname, force = true, recursive = true)
end
println("Test files deleted")