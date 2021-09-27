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
    rtid = _gen_id()
    _repo_update() do
	
        _set_pushflag()
        _set_iterfrec(3.0)
        
        _serialize_repo_rt(rtid, expr; long=true)
    end

    outfile = _repover(_out_rtlogfile(rtid))
    try
        println("\n\nFollowing task: ", rtid)
        _follow_and_print(outfile; tout = typemax(Int))
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end

    return :(nothing)
end