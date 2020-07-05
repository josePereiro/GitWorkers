function update_tasklocals_tests()
    cd(WORKERROOT)

    # Put someting in COPY_TASK local folder, created in the previous test
    exec_status_file = GW.build_task_exec_status_file(COPY_TASKROOT)
    @test begin
        mkpath(exec_status_file |> dirname)
        touch(exec_status_file)
        true
    end
    @assert isfile(exec_status_file)

    # Creating 
    @test begin
        GW.update_tasklocals()
        true
    end

    @test begin
        repo_test_file = GW.get_repotask_path(exec_status_file)
        isfile(repo_test_file)
    end

end
update_tasklocals_tests()