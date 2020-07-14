function control_files_tests()

    # Creating Test Treee
    root = TEST_DIR_ROOT |> abspath
    rm(root; force = true, recursive = true)
    @assert mkdir(root) |> isdir
    git_dir = joinpath(root, GW.GIT_DIR_NAME)
    @assert mkdir(git_dir) |> isdir

    # add worker
    workerroot = joinpath(root, "Worker")
    worker = workerroot |> GW.build_worker_file |> GW.create_file
    @assert workerroot |> isdir
    @assert worker |> isfile

    GW.reset()
    @test GW.get_config() |> isempty
    @test GW.get_status() |> isempty

    # ------------------- TEST ORIGIN CONFIG -------------------
    GW.set_config(1, "A")
    GW.set_config("bla", "A", "C")
    
    @test begin 
        GW.write_config(worker; create = true)
        true
    end
    origin_config_file = GW.build_origin_config_file(workerroot)
    @test origin_config_file |> GW.is_origin_config_file
    test_copy = GW.get_config() |> deepcopy
    @test test_copy == GW.read_config(worker)

    # ------------------- TEST LOCAL STATUS -------------------
    GW.set_status(1, "A")
    GW.set_status(rand(), "A", "C")
    
    @test begin 
        GW.write_status(worker; create = true)
        true
    end
    local_status_file = GW.build_local_status_file(workerroot)
    @test local_status_file |> GW.is_local_status_file
    test_copy = GW.get_status() |> deepcopy
    @test test_copy == GW.read_status(worker)

    # clearing
    rm(root; force = true, recursive = true)

end
control_files_tests()