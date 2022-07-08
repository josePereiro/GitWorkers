function _write_runme(trt::GWTaskRunTime)
    template = joinpath(@__DIR__, "templates", "task_proc_script.jl")
    script = runme_file(trt)
    _cp(template, script)
    return script
end

function _spawn_task_proc(gw::GitWorker, trt::GWTaskRunTime)

    # # OS SCRIPT
    runme = _write_runme(trt)

    # SPAWN
    cd(agent_dir(trt)) do

        projdir = pkgdir(GitWorkers)
        julia = _julia_cmd_str()
        out = out_file(trt)
        jlcmd = "$(julia) --startup-file=no --project=$(projdir) $(runme) -- -w >> $(out) 2>&1"
        proc_id = _spawn_bash(jlcmd; ignorestatus = false, dir = agent_dir(trt))
        write_status(trt, SPAWNED_STATUS)
        write_proc_reg(trt, proc_id)
        
        # LOG
        agent_id = agent_ider(trt)
        log_info(gw, "Task spawned"; agent_id, pid = proc_id)
        
    end

end