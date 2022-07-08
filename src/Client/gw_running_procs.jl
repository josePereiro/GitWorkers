function gw_running_procs()

    gw = gw_curr()
    rgw = repo_agent(gw)
    
    try
        while true
            
            send_force_push_signal(gitlink(gw)) # sync
            
            println("-"^60)

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