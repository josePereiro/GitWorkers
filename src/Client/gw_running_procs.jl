function gw_running_procs(; sync = true)

    gw = gw_curr()
    rgw = repo_agent(gw)
    
    try
        while true
            
            println("="^60)
            if sync
                gw_sync(; verbose = true)
                println("-"^60)
            end

            # deamon
            rdm = parent_agent(rgw)
            println("Deamon:")
            println.(readdir(procs_dir(rdm)))

            # worker
            println("\nWorker:")
            println.(readdir(procs_dir(rgw)))

            sleep(5.0)

        end
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end