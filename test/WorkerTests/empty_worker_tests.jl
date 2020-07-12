function empty_worker_tests()

    # ------------------- CREATING TREE -------------------
    root = "TestRoot" |> abspath
    rm(root; force = true, recursive = true)
    @assert mkdir(root) |> isdir
    @assert mkdir(joinpath(root, ".git")) |> isdir

    # add worker
    workerroot = joinpath(root, "Worker")
    worker = workerroot |> GW.build_worker_file |> GW.create_file
    @assert workerroot |> isdir
    @assert worker |> isfile

    # ------------------- TESTS -------------------
    @assert GW.ORIGIN_CONFIG |> isempty
    @assert GW.LOCAL_STATUS |> isempty
    @test begin
        GW.worker_loop(worker; verbose = false, deb = true, 
            iters = 1, maxwt = 0)
        true
    end
    @test GW.ORIGIN_CONFIG |> isempty
    @test GW.LOCAL_STATUS |> isempty

    # clear
    rm(root; force = true, recursive = true)
end
empty_worker_tests()