function workertree_tests()
    # is_workerroot
    @test WORKERROOT |> GW.is_workerroot
    @test NOT_WORKERROOT |> !GW.is_workerroot

    # is_worker
    @test GITWORKER |> GW.is_worker
    @test NOT_GITWORKER |> !GW.is_worker

    # is_inworker
    foreach([WORKERLEVEL_TESTFILES; TASKLEVEL_TESTFILES; 
            GITWORKER; TASK]) do f 
        @test GW.is_inworker(f)
    end
    foreach([NOT_GITWORKER; REPOLEVEL_TESTFILES]) do f 
        @test !GW.is_inworker(f)
    end

end
workertree_tests()