using GitWorkers
GW = GitWorkers
using Test

include("create_test_repo.jl")

@testset "GitWorkers.jl" begin
    include("TreeTests/TreeTests.jl")
    # include("UtilsTests/UtilsTests.jl")
end
