# ------------------------------------------------------------------
function _spawn_long_task(taskid, taskfile)

    # setup
    sysroot = _get_root()
    url = _get_url()
    # Connect proj with config
    projdir = Base.active_project()

    # log
    logfile = _local_tasklog(taskid)
    scriptfile = joinpath(@__DIR__, "long_task_script.jl")

    # TODO: connect with config for julia cmd
    julia = Base.julia_cmd()
    jlcmd = Cmd(`$julia --startup-file=no --project=$(projdir) -- $(scriptfile) $(taskid) $(taskfile) $(sysroot) $(url)`; detach = false)
    jlcmd = pipeline(jlcmd; stdout = logfile, stderr = logfile, append = true)
    run(jlcmd; wait = false)

    return nothing

end

function _spawn_long_tasks()

    taskfiles = _readdir(_local_tasksdir(); join = true)
    for taskfile in taskfiles

        # Check
        taskid, _ = _parse_long_task_name(taskfile)
        isempty(taskid) && (rm(taskfile; force = true); return)

        try
            _spawn_long_task(taskid, taskfile)
        catch err
            print("\n\n")
            GitWorkers._printerr(err)
            print("\n\n")
        end
    end
    
end
