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
macro gwspawn(expr)
    taskid = _gen_id()
    _repo_update(; verb = false ) do
	
        _set_pushflag()
        
        _serialize_repo_rt(taskid, expr; long=true)
        return true
    end

    outfile = _repover(_repo_tasklog(taskid))
    try
        println("\n\nFollowing task: ", taskid)
        _follow_and_print(outfile; tout = typemax(Int))
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end

    return :(nothing)
end