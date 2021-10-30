function _task_id(tag, date = now())
    tstr = Dates.format(date, "yyyymmdd\\THHMM")
    GitWorkers._gen_id(string(tstr, tag))
end

# ----------------------------------------------------------------
"""
    Take an expression and spawn it
"""
function _gw_spawn(expr::Expr, taskid; 
        follow = true, tout = 120.0,
        wt = 5.0, verb = false
    )

    !Meta.isexpr(expr, [:let, :block]) && error("A 'begin or let' block is expected. Ex: '@gw_spawn begin println(\"Hi\")' end")

    _repo_update(; verb) do
        _set_pushflag()
        _set_jlexpr_task(taskid, expr)
        return true
    end
    _set_last_task(taskid)

    follow && _follow_task(taskid; tout, wt)    

    return :(nothing)
end

_gw_spawn(f::Function, taskid; kwargs...) = _gw_spawn(f(), taskid; kwargs...)

"""
    Take the return f()::Expr and spawn it
"""
gw_spawn(expr::Expr; kwargs...) = _gw_spawn(expr, _task_id("SPANW"); kwargs...)
gw_spawn(f::Function; kwargs...) = _gw_spawn(f(), _task_id("SPANW"); kwargs...)

# ----------------------------------------------------------------
"""
    Capture the expression and spawn it
"""
macro gw_spawn(expr)
    GitWorkers.gw_spawn(expr; follow = true, tout = 120.0, wt = 5.0)
    return :(nothing)
end