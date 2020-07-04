function tasktree_tests()
    # is_taskroot
    @test TASKROOT |> GW.is_taskroot
    @test NOT_TASKROOT |> !GW.is_taskroot

    # is_task
    @test TASK |> GW.is_task
    foreach(NOT_TASKS) do f 
        @test !GW.is_task(f)
    end

    # is_intask
    foreach([TASKLEVEL_TESTFILES; TASK]) do f 
        @test GW.is_intask(f)
    end
    foreach([NOT_TASKS; WORKERLEVEL_TESTFILES; 
        REPOLEVEL_TESTFILES]) do f 
        @test !GW.is_intask(f)
    end

end
tasktree_tests()