function gw_list_tasks(; sync = true, repeat = 1)
    
    gw = gw_curr()
    it = 0

    try
        while true

            println("="^60)
            if sync
                gw_sync(; verbose = true)
                println("-"^60)
            end

            rgw = repo_agent(gw)
            for dir in sort!(_readdir(tasks_dir(rgw); join = true))
                rtrt = read_toml_file(GWTaskRunTime, dir)
                isnothing(rtrt) && continue
                ider = agent_ider(rtrt)
                status = read_status(rtrt)
                msg = string("Task '", ider, "' [", status, "]\n")
                if status == RUNNING_STATUS || status == SPAWNED_STATUS || status == NEW_STATUS
                    printstyled(msg; color = :yellow)
                elseif status == DONE_STATUS
                    printstyled(msg; color = :blue)
                else
                    printstyled(msg; color = :red)
                end
            end

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