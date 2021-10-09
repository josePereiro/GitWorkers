using GitWorkers
using Test

@testset "GitWorkers.jl" begin
    
    @testset "FileSystem" begin
        include("FileSystem_tests.jl")
    end
    
    @testset "TaskTest" begin
        include("task_tests.jl")
    end

end
