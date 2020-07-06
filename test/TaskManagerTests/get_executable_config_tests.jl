function get_executable_config_tests()

    # Non copy tasks are not executable
    @assert isfile(TASK) # From previous test
    @test !GW.get_executable_config(TASK)

    tasks = GW.find_tasks()
    @assert length(tasks) == 2 # From previous test

    # control_files
    @assert isdir(COPY_TASKROOT) # From previous test
    exec_config_file = GW.build_task_exec_config_file(COPY_TASKROOT)
    exec_status_file = GW.build_task_exec_status_file(COPY_TASKROOT)
    mkpath(exec_config_file |> dirname)
    mkpath(exec_status_file |> dirname)
    
    # Testing different posible states
    for (config, status, res) in [
            (missing, missing, false), # Missing config, Missing status
            (missing, nothing, false), # Missing config, Empty status
            (nothing, missing, false), # Empty config, Missing status
            (nothing, nothing, false), # Empty config, Empty status
            (1, missing, false), # Valid config, Missing status
            (missing, 1, false), # Missing config, Valid status
            (1, nothing, true), # Valid config, Empty status
            (nothing, 1, false), # Empty config, Valid status
            (1, 1, false), # Valid config, Valid status, config == status
            (1, 2, false), # Valid config, Valid status, config < status
            (2, 1, true), # Valid config, Valid status, config > status
        ]

        @test begin 
            rm(exec_config_file, force = true) 
            rm(exec_status_file, force = true) 

            if isnothing(config)
                touch(exec_config_file)
            elseif !ismissing(config)
                GW.write_control(exec_config_file, GW.EXE_ORDER_KEY, config)
            end 

            if isnothing(status)
                touch(exec_status_file)
            elseif !ismissing(status)
                GW.write_control(exec_status_file, GW.LAST_EXE_ORDER_KEY, status)
            end 

            true
        end
        @test GW.get_executable_config(COPY_TASK) == res

    end

end
get_executable_config_tests()