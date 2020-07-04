using GitWorkers
GW = GitWorkers
using Test

try
    include("prepare_tests.jl")

    @testset "GitWorkers.jl" begin
        include("TreeTests/TreeTests.jl")
        include("UtilsTests/UtilsTests.jl")
    end

finally
    include("clear_tests.jl")
end