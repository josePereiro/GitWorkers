function has_kill_config_tests()

    # Non copy tasks are killable
    @assert isfile(TASK) # From previous test
    @test !GW.has_kill_config(TASK)

    tasks = GW.find_tasks()
    @assert length(tasks) == 2 # From previous test

    # control_files
    @assert isdir(COPY_TASKROOT) # From previous test
    exec_config_file = GW.build_task_exec_config_file(COPY_TASKROOT)
    exec_status_file = GW.build_task_exec_status_file(COPY_TASKROOT)
    mkpath(exec_config_file |> dirname)
    mkpath(exec_status_file |> dirname)
            

    # Testing different posible states
    for (config, res) in [
            (missing, false), # Missing files
            ("Bla", false), # Invalid value
            (GW.KILL_SIGN, true) # Valid value
        ]
        @test begin 

            rm(exec_config_file, force = true) 
            rm(exec_status_file, force = true) 

            if isnothing(config)
                touch(exec_config_file)
            elseif !ismissing(config)
                GW.write_control(exec_config_file, GW.KILL_SIGN_KEY, config; check_type = false)
            end 
            
            true
        end
        
        @test GW.has_kill_config(COPY_TASK) == res
    end


end
has_kill_config_tests()