function _write_runme(gw::GitWorker)
    template = joinpath(@__DIR__, "templates", "worker_proc_script.jl")
    script = runme_file(gw)
    _cp(template, script)
    return script
end

function _spawn_worker_proc(dm::GWDeamon, gw::GitWorker)

    # OS SCRIPT
    scrfile = _write_runme(gw)

    # SPAWN
    mkpath(gw)

    cd(agent_dir(gw)) do

        projdir = pkgdir(GitWorkers)
        julia = Base.julia_cmd()
        jlcmd = Cmd(
            `$(julia) --startup-file=no --project=$(projdir) -- $(scrfile)`; 
            dir = agent_dir(gw)
        )
        worker_pid = _spawn_cmd(jlcmd)
        write_proc_reg(gw, worker_pid)
    
        # LOG
        worker_id = agent_ider(gw)
        log_info(dm, "Worker spawned"; worker_pid, worker_id)
    
    end
end