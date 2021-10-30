# ----------------------------------------------------------------
function gw_bash(src::AbstractString; 
        follow = true, tout = 120.0, 
        wt = 5.0, verb = false
    )

    taskid = _task_id("BASH")
    _repo_update(; verb) do
        _set_pushflag()
        _set_bash_task(taskid, src)
        return true
    end
    _set_last_task(taskid)

    follow && _follow_task(taskid; tout, wt, verb)

    return :(nothing)
end

gw_bash(f::Function; kwargs...) = gw_bash(f(); kwargs...)

# ----------------------------------------------------------------
"""
    Capture the expression and push it
"""
macro gw_bash_str(src)
    GitWorkers.gw_bash(src; follow = true, tout = 120.0, wt = 3.0, verb = false)
    return :(nothing) 
end