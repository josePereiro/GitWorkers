function gw_send_killsig(pid; unsafe = false, verb = false, tout = 120)
    
    try; 
        while true
            println("-"^60)
            println("Killing proc: ", pid)
            _gw_running_procs(;verb, tout)
            
            # check
            procreg = _find_procreg(pid; procsdir = _repo_procs_dir())
            if isempty(procreg)
                println("Process ", pid, " is dead!!! RIP")
                return
            end

            # TODO: Use killsignal
            # send signal
            println("Sending signal\n")
            expr = quote
                begin
                    if $(unsafe) || GitWorkers._validate_proc($(procreg))
                        GitWorkers.force_kill($(pid))
                    end
                end
            end
            _gw_spawn(expr; verb, follow = false)
            println("Signal sended\n\n")
        end
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end