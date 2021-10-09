# ------------------------------------------------------------------
function _spawn_long_task(taskid, taskfile)

    # setup
    sysroot = _get_root()
    url = _get_url()
    # Connect proj with config
    projdir = Base.active_project()

    # log
    logfile = _local_task_outfile(taskid)

    # unregister task
    raskcmd = deserialize(taskfile)
    _rm(taskfile)
    exprfile = _local_expr_file(taskid)
    serialize(exprfile, raskcmd.expr)
    
    # TODO: connect with config for julia cmd
    scriptfile = joinpath(@__DIR__, "long_task_script.jl")
    julia = Base.julia_cmd()
    jlcmd = Cmd(`$julia --startup-file=no --project=$(projdir) -- $(scriptfile) $(taskid) $(exprfile) $(sysroot) $(url)`; detach = false)
    jlcmd = pipeline(jlcmd; stdout = logfile, stderr = logfile, append = true)
    println("\n\n", "spawing task ", taskid, "\n\n")
    run(jlcmd; wait = false)

    return nothing

end

function _spawn_long_tasks()

    taskfiles = _readdir(_local_tasks_cmds_dir(); join = true)
    for taskfile in taskfiles

        # Check
        taskid, _ = _parse_long_task_name(taskfile)
        if isempty(taskid) 
            rm(taskfile; force = true)
            return
        end

        try
            _spawn_long_task(taskid, taskfile)
        catch err
            print("\n\n")
            GitWorkers._printerr(err)
            print("\n\n")
        end
    end
    
end
