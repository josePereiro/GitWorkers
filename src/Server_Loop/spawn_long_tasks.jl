function _spawn_long_tasks()

    taskfiles = _readdir(_local_tasks_cmds_dir(); join = true)
    for taskfile in taskfiles

        # Check
        taskid, _ = _parse_long_task_name(taskfile)
        if isempty(taskid) 
            rm(taskfile; force = true)
            continue
        end

        _with_server_loop_logger() do
            print("\n\n")
            @info("Spawing task", looppid = getpid(), taskid, time = now())
            print("\n\n")
        end

        try
            _spawn_long_task(taskid, taskfile)
        catch err
            _with_server_loop_logger() do
                print("\n\n")
                @error("At spawn task", looppid = getpid(), time = now(), err = _err_str(err))
                print("\n\n")
            end
        end
    end
    
end
