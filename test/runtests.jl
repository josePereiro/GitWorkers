using GitWorkers
GW = GitWorkers
using Test

@testset "GitWorkers.jl" begin
    include("UtilsTests/UtilsTests.jl")
    include("TreeTests/TreeTests.jl")
    include("GitTests/GitTests.jl")
    include("ControlFilesTests/ControlFilesTests.jl")
    include("WorkerTests/WorkerTests.jl")
end
