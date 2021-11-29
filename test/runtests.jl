using GitWorkers
const GW = GitWorkers
using Test

@testset "GitWorkers.jl" begin
    include("procs_reg_tests.jl")
end
