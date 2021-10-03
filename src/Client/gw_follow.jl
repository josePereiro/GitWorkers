# ----------------------------------------------------------------
function _follow_and_print(file; tout = 120.0, wt = 2.0, c0 = 0)

    lc = c0
    
    while true

        if isfile(file)
            lc = _print_file(file, lc) + 1
        end

        timeout = !_waitfor_size_change(file; tout, wt)
        timeout && return
    
    end # while true
end

# ----------------------------------------------------------------
function _follow_task(taskid; tout = 120.0, wt = 2.0, c0 = 0)
    isempty(taskid) && return

    logfile = _repo_tasklog(taskid)
    try

        println("\n")
        @info("Following task: ", taskid, logfile)
        println("\n")

        _follow_and_print(logfile; tout, wt, c0)

    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end

# ----------------------------------------------------------------
function gw_follow(taskid = _LAST_SPAWED_TASK[]; 
        tout = 120.0, wt = 2.0, c0 = 0
    )
    _follow_task(taskid; tout, wt, c0)
end