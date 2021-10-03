# ----------------------------------------------------------------
function _gw_spawn(expr; verb = false, follow = true, tout = 120.0, wt = 3.0)

    taskid = _gen_id()
    _repo_update(; verb = true) do
	
        _set_pushflag()
        _set_long_task(taskid, expr)
        return true
    end
    _LAST_SPAWED_TASK[] = taskid

    follow && _follow_task(taskid; tout, wt)    

    return :(nothing)

end

# ----------------------------------------------------------------
"""
    Capture the expression and push it
"""
macro gw_spawn(expr)
    GitWorkers._gw_spawn(expr; follow = true, tout = 120.0, wt = 3.0)
end