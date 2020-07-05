using GitWorkers
GW = GitWorkers
using Test

try
    include("prepare_tests.jl")

    @testset "GitWorkers.jl" begin
        # include order matter
        include("TreeTests/TreeTests.jl")
        include("UtilsTests/UtilsTests.jl")
        include("UpdaterTests/UpdaterTests.jl")
        include("TaskManagerTests/TaskManagerTests.jl")
    end
catch err
    rethrow(err)
finally
    include("clear_tests.jl")
end