function update_taskorigins_tests()

    # Working in worker
    cd(WORKERROOT)

    # Before update only one task
    taskroots = GW.findtasks_worker() .|> GW.get_taskroot
    @assert length(taskroots) == 1 
    @test GW.is_repotaskroot(taskroots[1]) && !GW.is_copytaskroot(taskroots[1])

    # Creating exec-config file
    exec_config_file = GW.build_task_exec_config_file(taskroots |> first)
    @test begin
        mkpath(exec_config_file |> dirname)
        touch(exec_config_file)
        true
    end

    # Updating 
    @test begin
        GW.sync_taskdirs(GW.REPO_ID, GW.ORIGIN_FOLDER_NAME)
        true
    end

    # Before the test we have a copy task
    taskroots = GW.findtasks_worker() .|> GW.get_taskroot
    @test length(taskroots) == 2
    @test GW.is_repotaskroot(taskroots[1]) == !GW.is_repotaskroot(taskroots[2])
    @test !GW.is_copytaskroot(taskroots[1]) == GW.is_copytaskroot(taskroots[2])

    # Both dirs equals
    @test all(readdir(joinpath(taskroots[1], GW.ORIGIN_FOLDER_NAME)) .== 
            readdir(joinpath(taskroots[2], GW.ORIGIN_FOLDER_NAME)))

    for taskroot in taskroots
        GW.is_repotaskroot(taskroot) && continue
        global COPY_TASKROOT = taskroot
        global COPY_TASK = GW.find_down(GW.TASK_FILE_NAME, COPY_TASKROOT)
        break;
    end

    @test isdir(COPY_TASKROOT) 
    @test isfile(COPY_TASK) && GW.is_task(COPY_TASK)


end
update_taskorigins_tests()