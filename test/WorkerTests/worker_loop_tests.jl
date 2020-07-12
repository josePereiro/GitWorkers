function worker_loop_tests()

    # ------------------- CREATING TREE -------------------
    root = "TestRoot" |> abspath
    rm(root; force = true, recursive = true)
    @assert mkdir(root) |> isdir
    @assert mkdir(joinpath(root, ".git")) |> isdir

    # worker
    workerroot = joinpath(root, "Worker")
    worker = workerroot |> GW.build_worker_file |> GW.create_file
    @assert workerroot |> isdir
    @assert worker |> isfile

    # ------------------- EMPTY WORKER TEST -------------------
    @assert GW.ORIGIN_CONFIG |> isempty
    @assert GW.LOCAL_STATUS |> isempty
    @test begin
        GW.worker_loop(worker; verbose = false, deb = true, 
            iters = 1, maxwt = 0)
        true
    end

    @test GW.ORIGIN_CONFIG |> isempty
    @test GW.LOCAL_STATUS |> isempty

    # ------------------- EMPTY TASK TEST -------------------

    # Add task
    taskroot = joinpath(workerroot, "Task")
    task = taskroot |> GW.build_task_file |> GW.create_file
    taskname = task |> GW.get_taskname
    @assert taskroot |> isdir
    @assert task |> isfile
    origin_dir = task |> dirname
    @test origin_dir |> basename == GW.ORIGIN_FOLDER_NAME
    local_dir = joinpath(taskroot, GW.LOCAL_FOLDER_NAME)
    @assert mkdir(local_dir) |> isdir

    @test begin
        GW.worker_loop(worker; verbose = false, deb = true, 
            iters = 1, maxwt = 0)
        true
    end

    @test GW.ORIGIN_CONFIG |> isempty
    @test haskey(GW.LOCAL_STATUS, taskname)

    # ------------------- EXECUTE TASK -------------------
    test_origin_config = Dict(taskname => Dict(GW.EXE_ORDER_KEY => Dict(GW.VALUE_KEY => 1)))
    GW.write_origin_config(test_origin_config, worker)
    @test GW.read_origin_config(worker) == test_origin_config

    # Test task
    test_file = joinpath(taskroot, "test_file.jl")
    @assert !isfile(test_file)
    write(task, 
        """
            write("$test_file", "bla"); 
        """
        )

    @test begin
        GW.worker_loop(worker; verbose = false, deb = true, 
            iters = 1, maxwt = 0)
        true
    end
    sleep(3) # waiting for task to finish
    @test isfile(test_file)

    # clearing
    rm(root; force = true, recursive = true)

end
worker_loop_tests()