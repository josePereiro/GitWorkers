# ----------------------------------------------------------------
function _follow_and_print(file; wkargs...)
    l0 = 1
    while true
        _waitfor_size_change(file; wkargs...)
        !isfile(file) && continue
        l = 1
        for line in eachline(file)
            (l >= l0) && println(line)
            l += 1
        end
        l0 = l
    end
end

# ----------------------------------------------------------------
"""
    Capture the expression and push it
"""
macro gw_spawn(expr)
    taskid = _gen_id()
    _repo_update(; verb = false ) do
	
        _set_pushflag()
        _set_long_task(taskid, expr)
        return true
    end

    logfile = _repo_tasklog(taskid)
    try
        @info("Following task: ", taskid, logfile)
        # HERE: Fix this is not printing
        _follow_and_print(logfile; tout = typemax(Int), wt = 2.0)
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end

    return :(nothing)
end