# ----------------------------------------------------------------
function gw_julia(src::AbstractString;
        follow = true, tout = 120.0, 
        wt = 3.0, verb = false
    )

    taskid = _gen_id()
    _repo_update(; verb) do
        _set_pushflag()
        _set_julia_task(taskid, src)
        return true
    end
    _LAST_SPAWED_TASK[] = taskid

    follow && _follow_task(taskid; tout, wt, verb)

    return :(nothing)
end

gw_julia(f::Function; kwargs...) = gw_julia(f(); kwargs...)

# ----------------------------------------------------------------
"""
    Capture the expression and push it
"""
macro gw_julia_str(src)
    GitWorkers.gw_julia(src; follow = true, tout = 120.0, wt = 3.0, verb = false)
    return :(nothing) 
end