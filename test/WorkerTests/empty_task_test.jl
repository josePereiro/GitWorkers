function empty_task_test()

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

    # add task
    taskroot = joinpath(workerroot, "Task")
    task = taskroot |> GW.build_task_file |> GW.create_file
    @assert taskroot |> isdir
    @assert task |> isfile

    # reset worker
    GW.reset()

    # ------------------- TESTS -------------------
    taskname = task |> GW.get_taskname
    origin_dir = task |> dirname
    @test origin_dir |> basename == GW.ORIGIN_FOLDER_NAME
    local_dir = joinpath(taskroot, GW.LOCAL_FOLDER_NAME)
    @assert mkdir(local_dir) |> isdir

    @test GW.get_config() |> isempty
    @test GW.get_status() |> isempty

    @test begin
        GW.worker_loop(workerroot; verbose = false, deb = true, 
            iters = 1, maxwt = 0)
        true
    end

    # testing control dicts
    @test GW.ORIGIN_CONFIG |> isempty

    @test !isnothing(GW.get_status(taskname, GW.EXEC_STATUS_KEY, GW.VALUE_KEY))
    @test !GW.get_status(taskname, GW.EXEC_STATUS_KEY, GW.VALUE_KEY)

    @test !isnothing(GW.get_status(taskname, GW.RUNNING_STATUS_KEY, GW.VALUE_KEY))
    @test !GW.get_status(taskname, GW.RUNNING_STATUS_KEY, GW.VALUE_KEY)

    @test !isnothing(GW.get_status(taskname, GW.KILL_STATUS_KEY, GW.VALUE_KEY))
    @test !GW.get_status(taskname, GW.KILL_STATUS_KEY, GW.VALUE_KEY)

    # clear
    rm(root; force = true, recursive = true)
end
empty_task_test()