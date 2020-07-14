function control_files_tests()

    # Creating Test Treee
    root = "TestRoot" |> abspath
    rm(root; force = true, recursive = true)
    @assert mkdir(root) |> isdir

    git_dir = joinpath(root, GW.GIT_DIR_NAME)
    @assert mkdir(git_dir) |> isdir

    dict = Dict()
    dict["A"] = 1
    dict["B"] = "bla"

    worker = root |> GW.build_worker_file |> GW.create_file
    @assert worker |> isfile

    origin_config_file = GW.build_origin_config_file(root)
    @test begin 
        GW.write_config(dict, worker; create = true)
        true
    end
    @test origin_config_file |> GW.is_origin_config_file
    @test dict == GW.read_config(worker)

    @test begin 
        GW.write_status(dict, worker; create = true)
        true
    end
    local_status_file = GW.build_local_status_file(root)
    @test local_status_file |> GW.is_local_status_file
    @test dict == GW.read_status(worker)

    # clearing
    rm(root; force = true, recursive = true)

end
control_files_tests()