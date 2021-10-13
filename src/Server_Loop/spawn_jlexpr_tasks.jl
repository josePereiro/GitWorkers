function _spawn_jlexpr_tasks()

    taskfiles = _readdir(_local_tasks_cmds_dir(); join = true)
    for taskfile in taskfiles

        # Check
        taskid, _ = _parse_jlexpr_task_name(taskfile)
        if isempty(taskid) 
            rm(taskfile; force = true)
            continue
        end

        print("\n\n")
        @info("Spawing task", looppid = getpid(), taskid, time = now())
        print("\n\n")

        try
            _spawn_jlexpr_task(taskid, taskfile)
        catch err
            
            print("\n\n")
            @error("At spawn task", looppid = getpid(), time = now(), err = _err_str(err))
            print("\n\n")

        end
    end
    
end
