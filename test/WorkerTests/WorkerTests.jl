@testset "WorkerTests.jl" begin
    include("wait_for.jl")
    # include("empty_worker_tests.jl")
    # include("empty_task_test.jl")
    include("quick_task_tests.jl")
    include("long_task_tests.jl")
end