# ----------------------------------------------------------------
"""
    Take an expression and spawn it
"""
function gw_spawn(expr::Expr; 
        follow = true, tout = 120.0,
        wt = 3.0, verb = false
    )

    !Meta.isexpr(expr, [:let, :block]) && error("A 'begin or let' block is expected. Ex: '@gw_spawn begin println(\"Hi\")' end")

    taskid = _gen_id()
    _repo_update(; verb) do
        _set_pushflag()
        _set_jlexpr_task(taskid, expr)
        return true
    end
    _LAST_SPAWED_TASKID[] = taskid

    follow && _follow_task(taskid; tout, wt)    

    return :(nothing)
end

"""
    Take the return f()::Expr and spawn it
"""
gw_spawn(f::Function; kwargs...) = gw_spawn(f(); kwargs...)

# ----------------------------------------------------------------
"""
    Capture the expression and spawn it
"""
macro gw_spawn(expr)
    GitWorkers.gw_spawn(expr; follow = true, tout = 120.0, wt = 3.0)
    return :(nothing)
end