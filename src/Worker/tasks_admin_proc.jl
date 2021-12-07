const _GW_TASKS_ADMIN_PROC_PTAG = "TASKS-ADMIN"
const _GW_TASKS_ADMIN_OS_UP_FREC = 3.0

## ---------------------------------------------------------------
# OS
function _run_tasks_admin_proc_os(gw::GitWorker)

    while true
        # PROC REGISTRY
        _reg_proc(gw, _GW_TASKS_ADMIN_PROC_PTAG)

        sleep(_GW_TASKS_ADMIN_OS_UP_FREC)
    end

end

function _download_tasks(rtdir, ltdir)
    mkpath(ltdir)
    for rtask in _readdir(rtdir; join = true)
        !isdir(rtask) && continue # ignore files
        ltask = joinpath(ltdir, basename(rtask))
        isdir(ltask) && continue # ignore already down (lazy)
        _cp(rtask, ltask)
    end
end

# TODO: add mtime event handler
function _spawn_tasks(tasksdir)
    for taskdir in readdir(tasksdir; join = true)
        gwt = _load_task(taskdir)
        isnothing(gwt) && continue
        !_is_pending_task(gwt) && continue

        @info("Spawing task", tid = task_id(gwt))
        _spawn_runme(gwt)
        _up_task_status(gwt, _GW_TASK_SPAWNED_STATUS)
    end
end

function _upload_tasks(gl::GitLink, ltdir, rtdir)
    for ltask in readdir(ltdir; join = true)
        gwt = _load_task(ltask)
        isnothing(gwt) && continue
        
        out_log = _taskout_file(gwt)
        _on_mtime_event(out_log) do # If out change
            @info("Uploading task", tid = task_id(gwt))
            writewdir(gl; verbose = true) do _
                rtask = joinpath(rtdir, basename(ltask))
                _cp(ltask, rtask)
            end
        end
    end
end

function _run_tasks_admin_loop(gw::GitWorker)

    mkpath(gw)

    # gitlink
    gl = gitlink(gw)

    ltdir = tasks_dir(gw) # local
    rtdir = repo_mirpath(gw, ltdir)
    mkpath(ltdir)

    _download_tasks(rtdir, ltdir)

    while true
    
        # DOWNLOAD NEW TASKS
        # if_pull(gl) do
            _download_tasks(rtdir, ltdir)
            # up_pull_reg!(gl)
        # end

        # SPAWN TASKS
        _spawn_tasks(ltdir)

        # UPLOAD TASKS
        _upload_tasks(gl, ltdir, rtdir)

        sleep(5.0)

    end # while true

end

## ---------------------------------------------------------------
function _create_tasks_admin_proc_script(gw::GitWorker, scrfile)
    
    tfile = joinpath(@__DIR__, "tasks_admin_script_template.jl")
    src = read(tfile, String)

    sroot = sys_root(gw)
    src = replace(src, "__SYS_ROOT__" => sroot)
    url = remote_url(gw)
    src = replace(src, "__REMOTE_URL__" => url)
    src = replace(src, "__PTAG__" => _GW_TASKS_ADMIN_PROC_PTAG)

    _mkdir(scrfile)
    write(scrfile, src)

    return scrfile
end

## ---------------------------------------------------------------
# SPAWN TASKS ADMIN PROC
function _spawn_tasks_admin_proc(gw::GitWorker)

    _is_running(gw, _GW_TASKS_ADMIN_PROC_PTAG) && return

    scrfile = tempname()
    _create_tasks_admin_proc_script(gw, scrfile)
    
    projdir = pkgdir(GitWorkers)
    julia = Base.julia_cmd()
    jlcmd = Cmd(
        `$(julia) --startup-file=no --project=$(projdir) $(scrfile)`; 
        dir = homedir(), ignorestatus = false
    )
    # run(jlcmd; wait = false)
    run(jlcmd; wait = true)

    return false
end
