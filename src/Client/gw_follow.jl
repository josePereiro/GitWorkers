# ----------------------------------------------------------------
function _follow_and_print(file, stophint; 
        tout = 120.0, wt = 5.0, c0 = 0, 
        buffsize = 500,
        verb = false
    )
    
    # collect tail
    # the tail needs to be long enought to the 'stophint' to be contained for sure
    tailstr::String = ""
    function onprint(str)
        tailstr = last(string(tailstr, str), buffsize)
    end
    
    lc = c0
    while true

        if isfile(file)
            lc = _print_file(file, lc; onprint, buffsize) + 1
        end

        finished = contains(tailstr, stophint)
        finished && return
    
        timeout = !_waitfor_size_change(file; tout, wt, verb)
        timeout && return
        
    end # while true
end

# ----------------------------------------------------------------
function _task_finished_regex_hint(taskid)
    # from jlexpr task script end tag
    # println("\n", rpad("FINISHED ", 60, "-"))
    # println("pid: ", getpid())
    # println("task id: ", _GW_TASKID)
    return Regex("FINISHED\\s*-+\\s*\n\\s*pid:\\s*[0-9]+\\s*\n\\s*task\\s*id:\\s*$(taskid)\\s*")
end

# ----------------------------------------------------------------
function _follow_task(taskid; tout = 120.0, wt = 5.0, c0 = 0, verb = false)
    isempty(taskid) && return

    out_file = _repo_task_out_file(taskid)
    stophint = _task_finished_regex_hint(taskid)
    try

        println("\n")
        @info("Following task: ", taskid)
        println("\n")

        _follow_and_print(out_file, stophint; tout, wt, c0, verb)

    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end

# ----------------------------------------------------------------
function gw_follow(taskid = gw_last_task(); 
        tout = 120.0, wt = 5.0, c0 = 0
    )
    _follow_task(taskid; tout, wt, c0)
end