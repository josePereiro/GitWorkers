function gw_send_killer(hint)
    hint = string(hint)

    ex = quote
        import GitWorkers

        killer_trt = GitWorkers.gw_curr_task()

        if !GitWorkers._is_valid_proc(killer_trt, $(hint)) 
            @info("No one to kill ;(", hint = $(hint))
            return
        end

        reg = GitWorkers._findfirst_proc_reg(killer_trt, $(hint))

        for t in 1:10

            GitWorkers._is_valid_proc(killer_trt, $(hint)) || break
            
            @info("Killing ", 
                hint = $(hint), 
                reg = basename(reg)
            )

            GitWorkers._safe_killall(killer_trt, $(hint))
            
            sleep(3.0)
            
        end

        if GitWorkers._is_valid_proc(killer_trt, $(hint))
            @warn("Tough guy, kill failed ;(", hint = $(hint))
        else
            @info("RIP", hint = $(hint))
            # TODO: find reg owner (to_kill) and change its status
            # GitWorkers.write_status(to_kill, KILLED_STATUS)
        end

    end

    _gw_spawn(gw_curr(), ex, "KILLER")
    
end