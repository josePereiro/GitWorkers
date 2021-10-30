function gw_send_killsig(tokill; 
        unsafe = false,
        tries = 5, wtries = 2, 
        verb = false, wt = 5, tout = 120
    )

    tries = max(tries, 1)
    wtries = max(wtries, 1)
    
    try; 
        while true

            println("-"^60)
            println("Killing proc: ", tokill)
            _gw_running_procs(;verb, tout)
            sleep(wt)

            println("Sending kill task")
            taskid = _gen_id("KILLTASK")
            _gw_spawn(taskid; follow = true, tout, verb) do 
                return quote
                    let 
                        # interpolate
                        tokill = $(tokill)
                        unsafe = $(unsafe)
                        tries = $(tries)

                        # procreg
                        procreg = GitWorkers._find_procreg(tokill; procsdir = GitWorkers._local_procs_dir())
                        @show basename(procreg)
                        isvalidproc = GitWorkers._validate_proc(procreg)

                        # protect the system processes
                        if !unsafe && !isvalidproc
                            @warn(string(tokill, " is not worker spanwed process, run 'gw_running_procs' to see or use 'unsave' to force killing!!!"), 
                                looppid = getpid(), 
                                time = GitWorkers.now()
                            )
                            return
                        end

                        if !unsafe && (contains(basename(procreg), GitWorkers._GW_SERVER_LOOP_PROC_TAG) || 
                            contains(basename(procreg), GitWorkers._GW_SERVER_MAIN_PROC_TAG))
                            @warn(string(tokill, " is protected, use 'unsave' to force killing!!!"), 
                                looppid = getpid(), 
                                time = GitWorkers.now()
                            )
                            return
                        end
                        
                        for t in 1:tries
                            # read signal
                            isvalidproc = GitWorkers._validate_proc(procreg)
                            !isvalidproc && break
                            
                            @warn("Executing kill sig", 
                                looppid = getpid(), 
                                tokill, unsafe, isvalidproc,
                                time = GitWorkers.now()
                            )
                            println()
                            GitWorkers._safe_kill(tokill; unsafe)
                            sleep($(wt))
                        end

                        isvalidproc = GitWorkers._validate_proc(procreg)
                        println()
                        if isvalidproc
                            @warn(string("Killing fails after ", tries, " tries"))
                        else
                            @info(string(tokill, " is dead, RIP!!!"))
                        end
                    end
                end
            end # _gw_spawn
            
            for _ in 1:wtries
                println("Updating procs, curriter: ", _get_curriter())
                timeout = !_waitfor_till_next_iter(;verb, tout)
                timeout && return
                
                # check
                procreg = _find_procreg(tokill; procsdir = _repo_procs_dir())
                if isempty(procreg)
                    println("\nDone")
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