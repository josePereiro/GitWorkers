function workertree_tests()

    # creating tree
    root = "TestRoot" |> abspath
    rm(root; force = true, recursive = true)
    @assert mkdir(root) |> isdir
    no_root = joinpath(root, "sub")
    @assert mkdir(no_root) |> isdir

    worker = root |> GW.build_worker_file |> GW.create_file
    @assert isfile(worker)

    test_file ="test_file.jl"
    worker_files = map(0:rand(3:8)) do i
        return joinpath(root, fill("sub", i)..., test_file)
    end |> sort .|> abspath
    no_worker = worker_files[1]
    @assert issorted(worker_files)
    @assert all(isabspath.(worker_files))
    foreach(GW.create_file, worker_files)
    @test all(isfile.(worker_files))
    non_worker_file = joinpath(test_file)
    GW.create_file(non_worker_file)
    @assert isfile(non_worker_file)

    # is_workerroot
    @test root |> GW.is_workerroot
    @test no_root |> !GW.is_workerroot

    # is_worker
    @test worker |> GW.is_worker
    @test no_worker |> !GW.is_worker

    # is_inworker
    foreach(worker_files) do f 
        @test GW.is_inworker(f, worker)
    end
    @test !GW.is_inworker(non_worker_file, worker)

    rm(root; force = true, recursive = true)
    rm(non_worker_file, force = true)
end
workertree_tests()