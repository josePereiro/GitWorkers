function _print_procs_info(pdir)
    i = 1
    for regname in _readdir(pdir)
        agent_ider, pid, vhash = _parse_proc_reg_name(regname)
        isempty(agent_ider) && continue
        println("[", i, "] pid: ", pid, ", agent id: ", agent_ider)
        i += 1
    end
end

function gw_running_procs(; sync = true, repeat = 1)

    gw = gw_curr()
    rgw = repo_agent(gw)
    it = 0
    
    try
        while true
            
            println("="^60)
            if sync
                gw_sync(; verbose = true)
                println("-"^60)
            end

            # deamon
            rdm = parent_agent(rgw)
            println("Deamon's procs:")
            _print_procs_info(procs_dir(rdm))

            # worker
            println("\nWorker's procs:")
            _print_procs_info(procs_dir(rgw))

            it += 1
            it >= repeat && return

            println()
            sleep(3.0)

        end
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end