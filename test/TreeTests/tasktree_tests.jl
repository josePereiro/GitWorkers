function tasktree_tests()

    # ------------------- CREATING TREE -------------------
    workerroot = TEST_DIR_ROOT |> abspath
    rm(workerroot; force = true, recursive = true)
    @assert mkdir(workerroot) |> isdir
    git_dir = joinpath(workerroot, ".git")
    @assert mkdir(git_dir) |> isdir
    worker = workerroot |> GW.build_worker_file |> GW.create_file
    @assert isfile(worker)

    no_root = joinpath(workerroot, "sub")
    @assert mkdir(no_root) |> isdir

    taskroot = joinpath(workerroot, "Task")
    task = taskroot |> GW.build_task_file |> GW.create_file
    @assert isfile(task)

    # is_taskroot
    @test taskroot |> GW.is_taskroot
    @test no_root |> !GW.is_taskroot

    test_file ="test_file.jl"
    task_files = map(0:rand(3:8)) do i
        return joinpath(taskroot, fill("sub", i)..., test_file)
    end |> sort .|> abspath
    no_task = task_files[1]
    @assert issorted(task_files)
    @assert all(isabspath.(task_files))
    foreach(GW.create_file, task_files)
    @test all(isfile.(task_files))
    non_task_file = joinpath(workerroot, test_file)
    GW.create_file(non_task_file)
    @assert isfile(non_task_file)

    # is_task
    @test task |> GW.is_task
    @test !GW.is_task(non_task_file)

    # is_intask
    foreach(task_files) do f 
        @test GW.is_intask(f)
    end
    @test non_task_file |> !GW.is_intask

    rm(workerroot; force = true, recursive = true)
end
tasktree_tests()