

function worker_loop_tests()

    
    
    # ------------------- EMPTY WORKER TEST -------------------
    empty_worker_tests(worker)

    # ------------------- EMPTY TASK TEST -------------------

    

    

    # # ------------------- EXECUTE TASK -------------------
    # exec_order = 1
    # test_origin_config = 
    # Dict(taskname => Dict(GW.EXE_ORDER_KEY => Dict(GW.VALUE_KEY => exec_order)))
    # GW.write_origin_config(test_origin_config, worker)
    # @test GW.read_origin_config(worker) == test_origin_config
    
    # test_file = joinpath(taskroot, "test_file.jl")
    # stdout_log_file = GW.get_stdout_file(task, exec_order)
    # stderr_log_file = GW.get_stderr_file(task, exec_order)

    # # ------------------- QUICK TASK -------------------
    # quick_task_tests()

    # # ------------------- SLOW TASK -------------------
    # rm(test_file , force = true)
    # @assert test_file |> isfile
    # write(task, 
    #     """
    #         print(stdout, $stdout_secret)
    #         print(stderr, $stderr_secret)
    #         flush(stdout)
    #         flush(stderr)
    #         sleep(10)
    #         write("$test_file", pwd());
    #     """
    # )

    # clearing
    # rm(root; force = true, recursive = true)

end
worker_loop_tests()