using GitWorkers
GW = GitWorkers
using Test

@testset "GitWorkers.jl" begin
    include("UtilsTests/UtilsTests.jl")
    include("TreeTests/TreeTests.jl")
    # include("UpdaterTests/UpdaterTests.jl")
    # include("TaskManagerTests/TaskManagerTests.jl")
end
