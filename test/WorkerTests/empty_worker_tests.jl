function empty_worker_tests()

    # ------------------- CREATING TREE -------------------
    root = TEST_DIR_ROOT |> abspath
    rm(root; force = true, recursive = true)
    @assert mkdir(root) |> isdir
    @assert mkdir(joinpath(root, ".git")) |> isdir

    # add worker
    workerroot = joinpath(root, "Worker")
    worker = workerroot |> GW.build_worker_file |> GW.create_file
    @assert workerroot |> isdir
    @assert worker |> isfile

    # reset worker
    GW.reset()
    
    # ------------------- TESTS -------------------
    @assert GW.get_config() |> isempty
    @assert GW.get_status() |> isempty
    @test begin
        GW.worker_loop(worker; verbose = false, deb = true, 
            iters = 1, maxwt = 0)
        true
    end
    @test GW.get_config() |> isempty
    @test GW.get_status() |> isempty

    # clear
    rm(root; force = true, recursive = true)
end
empty_worker_tests()