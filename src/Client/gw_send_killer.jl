function gw_send_killer(hint)
    hint = string(hint)

    ex = quote
        import GitWorkers

        trt = GitWorkers.gw_curr_task()

        if !GitWorkers._is_valid_proc(trt, $(hint)) 
            @info("No one to kill ;(", hint = $(hint))
            return
        end

        for t in 1:10

            GitWorkers._is_valid_proc(trt, $(hint)) || break
            
            @info("Killing ", 
                hint = $(hint), 
                reg = basename(GitWorkers._findfirst_proc_reg(trt, $(hint)))
            )

            GitWorkers._safe_killall(trt, $(hint))
            
            sleep(3.0)
            
        end

        GitWorkers._is_valid_proc(trt, $(hint)) ? 
            @warn("Tough guy, kill failed ;(", hint = $(hint)) :
            @info("RIP", hint = $(hint))

    end

    _gw_spawn(gw_curr(), ex, "KILLER")
    
end