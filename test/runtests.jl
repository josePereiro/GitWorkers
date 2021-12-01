using GitWorkers
const GW = GitWorkers
using Test

@testset "GitWorkers.jl" begin
    include("procs_reg_tests.jl")
    include("safe_kill_test.jl")
    include("spawn_scripts_tests.jl")
    include("task_eotask_tests.jl")
end
