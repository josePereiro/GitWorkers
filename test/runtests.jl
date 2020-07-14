using GitWorkers
GW = GitWorkers
using Test

TEST_DIR_ROOT = "TestRoot"

try
    @testset "GitWorkers.jl" begin
        include("UtilsTests/UtilsTests.jl")
        include("TreeTests/TreeTests.jl")
        include("GitTests/GitTests.jl")
        include("ControlFilesTests/ControlFilesTests.jl")
        include("WorkerTests/WorkerTests.jl")
    end
finally
    root = TEST_DIR_ROOT |> abspath
    rm(root; force = true, recursive = true)
end