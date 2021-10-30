function gw_send_killsig(pid; tries = 5, wtries = 2, unsafe = false, verb = false, tout = 120)

    tries = max(tries, 1)
    wtries = max(wtries, 1)
    
    try; 
        while true

            println("-"^60)
            println("Killing proc: ", pid)
            _gw_running_procs(;verb, tout)

            println("Sending kill signal")
            _repo_update(;verb) do
		
                _set_pushflag()
                _set_killsig(pid; unsafe)
                
                return true
            end
            println("Signal sent", "\n\n")
            
            for _ in 1:wtries
                println("Waiting, curriter: ", _get_curriter())
                timeout = !_waitfor_till_next_iter(;verb, tout)
                timeout && return
                
                # check
                procreg = _find_procreg(pid; procsdir = _repo_procs_dir())
                if isempty(procreg)
                    println("\nProcess ", pid, " is dead!!! RIP")
                    return
                end
                sleep(3.0)
            end

            tries -= 1; (tries < 1) && return
            println("\n\n")
        end
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end