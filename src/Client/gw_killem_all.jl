function gw_killem_all()
    
    ex = quote
        import GitWorkers

        trt0 = GitWorkers.gw_curr_task()
        ider0 = GitWorkers.agent_ider(trt0)
        gw =  GitWorkers.parent_worker(trt0)

        # collect
        to_kill = GitWorkers.GWTaskRunTime[]
        for (_, trt) in GitWorkers.collect_tasks!(gw)
            ider0 == GitWorkers.agent_ider(trt) && continue
            GitWorkers.is_running(trt) && push!(to_kill, trt)
        end

        if isempty(to_kill)
            println("No one to kill ;(")
            return
        end
        
        for trt in to_kill

            ider = GitWorkers.agent_ider(trt)

            for t in 1:10

                println("Killing '$(ider)'")
                GitWorkers.is_running(trt) || break
                GitWorkers.safe_kill(trt)
                sleep(1.0)
                
            end

            GitWorkers.is_running(trt) ? 
                println("Tough guy '", ider, "', kill failed ;(") :
                println("RIP ", ider)
            
            println("\n"^2)

        end

    end

    _gw_spawn(gw_curr(), ex, "KILLEM_ALL")
end