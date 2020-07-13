function quick_task_test()

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

    # add task
    taskroot = joinpath(workerroot, "Task")
    task = taskroot |> GW.build_task_file |> GW.create_file
    @assert taskroot |> isdir
    @assert task |> isfile

    # reset worker
    GW.reset()

    # ------------------- PREPARE TASK -------------------
    origin_dir = task |> dirname
    @test origin_dir |> isdir
    local_dir = joinpath(taskroot, GW.LOCAL_FOLDER_NAME)
    @assert local_dir |> mkdir |> isdir

    taskname = task |> GW.get_taskname
    exec_order = rand(1:1000)
    test_origin_config = 
    Dict(taskname => Dict(GW.EXEC_ORDER_KEY => Dict(GW.VALUE_KEY => exec_order)))
    GW.write_origin_config(test_origin_config, worker)
    @test GW.read_origin_config(worker) == test_origin_config

    test_file = joinpath(taskroot, "test_file.jl")
    @assert !isfile(test_file)
    stdout_secret = rand(Int128) |> string
    stderr_secret = rand(Int128) |> string

    # Program task
    write(task, 
        """
            print(stdout, $stdout_secret)
            print(stderr, $stderr_secret)
            flush(stdout)
            flush(stderr)
            write("$test_file", pwd());
        """
    )

    # ------------------- ONE WORKER LOOP -------------------
    @test begin
        GW.worker_loop(worker; verbose = false, deb = true, 
            iters = 1, maxwt = 0)
        true
    end

    # testing control dicts
    @test haskey(GW.ORIGIN_CONFIG, taskname)
    @test haskey(GW.ORIGIN_CONFIG[taskname], GW.EXEC_ORDER_KEY)
    @test haskey(GW.ORIGIN_CONFIG[taskname][GW.EXEC_ORDER_KEY], GW.VALUE_KEY)
    # exec_order
    @test GW.ORIGIN_CONFIG[taskname][GW.EXEC_ORDER_KEY][GW.VALUE_KEY] == exec_order

    @test haskey(GW.LOCAL_STATUS, taskname)
    @test haskey(GW.LOCAL_STATUS[taskname], GW.EXECUTION_STATUS_KEY)
    @test haskey(GW.LOCAL_STATUS[taskname][GW.EXECUTION_STATUS_KEY], GW.VALUE_KEY)
    # After one loop the status must be 'true', it will be updated the next loop
    @test GW.LOCAL_STATUS[taskname][GW.EXECUTION_STATUS_KEY][GW.VALUE_KEY]

    @test haskey(GW.LOCAL_STATUS[taskname], GW.RUNNING_STATUS_KEY)
    @test haskey(GW.LOCAL_STATUS[taskname][GW.RUNNING_STATUS_KEY], GW.VALUE_KEY)
    # After one loop the status must be 'false', no task must be running
    @test !GW.LOCAL_STATUS[taskname][GW.RUNNING_STATUS_KEY][GW.VALUE_KEY]

    @test haskey(GW.LOCAL_STATUS[taskname], GW.KILL_STATUS_KEY)
    @test haskey(GW.LOCAL_STATUS[taskname][GW.KILL_STATUS_KEY], GW.VALUE_KEY)
    # After one loop the status must be 'false', no kill sign added to origin
    @test !GW.LOCAL_STATUS[taskname][GW.KILL_STATUS_KEY][GW.VALUE_KEY]

    # waiting for task to finish
    wait_for() do
        isfile(test_file)
    end
    @test isfile(test_file)
    @test read(test_file, String) |> GW.get_repotask_path == origin_dir

    # ------------------- MANY WORKER LOOP -------------------
    stdout_log_file = GW.get_stdout_file(task, exec_order)
    stderr_log_file = GW.get_stderr_file(task, exec_order)
    # Log files must be in the copy folder still, in the next iteration will 
    # be copied to the repo task folder
    @test !isfile(stdout_log_file)
    @test !isfile(stderr_log_file)

    wait_for(wtime = 30) do
        GW.worker_loop(worker; verbose = false, deb = true, 
            iters = 1, maxwt = 0)
            
        return isfile(stdout_log_file) &&
            occursin(stdout_secret, read(stdout_log_file, String)) &&
            isfile(stderr_log_file) &&
            occursin(stderr_secret, read(stderr_log_file, String))
    end
    # The log files must be created and contained the secret words
    @test isfile(stdout_log_file) 
    @test occursin(stdout_secret, read(stdout_log_file, String))
    @test isfile(stderr_log_file)
    @test occursin(stderr_secret, read(stderr_log_file, String))

    # testing control dicts
    @test haskey(GW.ORIGIN_CONFIG, taskname)
    @test haskey(GW.ORIGIN_CONFIG[taskname], GW.EXEC_ORDER_KEY)
    @test haskey(GW.ORIGIN_CONFIG[taskname][GW.EXEC_ORDER_KEY], GW.VALUE_KEY)
    # After many loops the status must be the same, workes can't change this
    @test GW.ORIGIN_CONFIG[taskname][GW.EXEC_ORDER_KEY][GW.VALUE_KEY] == exec_order

    @test haskey(GW.LOCAL_STATUS, taskname)
    @test haskey(GW.LOCAL_STATUS[taskname], GW.EXECUTION_STATUS_KEY)
    @test haskey(GW.LOCAL_STATUS[taskname][GW.EXECUTION_STATUS_KEY], GW.VALUE_KEY)
    # After many loops the status must be equal to the current (and unique) exec order
    @test GW.LOCAL_STATUS[taskname][GW.EXECUTION_STATUS_KEY][GW.LAST_EXEC_ORDER_KEY] == exec_order
    # After many loops the status must be 'false', the last exec order was updated
    @test !GW.LOCAL_STATUS[taskname][GW.EXECUTION_STATUS_KEY][GW.VALUE_KEY]

    @test haskey(GW.LOCAL_STATUS[taskname], GW.RUNNING_STATUS_KEY)
    @test haskey(GW.LOCAL_STATUS[taskname][GW.RUNNING_STATUS_KEY], GW.VALUE_KEY)
    # After many loops the status must be 'false', the task is too fast for have 
    # a running state at this point
    @test !GW.LOCAL_STATUS[taskname][GW.RUNNING_STATUS_KEY][GW.VALUE_KEY]

    @test haskey(GW.LOCAL_STATUS[taskname], GW.KILL_STATUS_KEY)
    @test haskey(GW.LOCAL_STATUS[taskname][GW.KILL_STATUS_KEY], GW.VALUE_KEY)
    # The same than last time
    @test !GW.LOCAL_STATUS[taskname][GW.KILL_STATUS_KEY][GW.VALUE_KEY]

    # clear
    rm(root; force = true, recursive = true)
end
quick_task_test()