function tasktree_tests()

    # creating tree
    root = "TestRoot" |> abspath
    rm(root; force = true, recursive = true)
    @assert mkdir(root) |> isdir
    no_root = joinpath(root, "sub")
    @assert mkdir(no_root) |> isdir

    task = root |> GW.build_task_file |> GW.create_file
    @assert isfile(task)

    test_file ="test_file.jl"
    task_files = map(0:rand(3:8)) do i
        return joinpath(root, fill("sub", i)..., test_file)
    end |> sort .|> abspath
    no_task = task_files[1]
    @assert issorted(task_files)
    @assert all(isabspath.(task_files))
    foreach(GW.create_file, task_files)
    @test all(isfile.(task_files))
    non_task_file = joinpath(test_file)
    GW.create_file(non_task_file)
    @assert isfile(non_task_file)

    # is_taskroot
    @test root |> GW.is_taskroot
    @test no_root |> !GW.is_taskroot

    # is_task
    @test task |> GW.is_task
    @test !GW.is_task(non_task_file)

    # is_intask
    foreach(task_files) do f 
        @test GW.is_intask(f)
    end
    @test non_task_file |> !GW.is_intask

    rm(root; force = true, recursive = true)
    rm(non_task_file, force = true)
end
tasktree_tests()