# ----------------------------------------------------------------
"""
    Take an expression and spawn it
"""
function _gw_spawn(gw::GitWorker, ex::Expr, tname; 
        follow = true, tout = 120.0,
        wt = 5.0, verb = false
    )

    !Meta.isexpr(ex, [:let, :block]) && error("A 'begin or let' block is expected. Ex: '@gw_spawn begin println(\"Hi\")' end")

    # task id
    tid = _task_id(tname)
    
    # readme
    readme = _readme(;tid, 
        src = _expr_src(ex), 
        desc = "Hi, no description provided!!!", 
        lang = "julia"
    )

    ok_flag = _upload_jltask(gw,
        tid, ex; readme,
        vtime = _GW_DFLT_TASK_VTIME
    )

    if ok_flag
        @info("Task uploaded")
    else
        @error("Task uploading fail")
    end

    return :(nothing)
end

_gw_spawn(f::Function, taskid; kwargs...) = _gw_spawn(f(), taskid; kwargs...)

"""
    Take the return f()::Expr and spawn it
"""
gw_spawn(ex::Expr; kwargs...) = _gw_spawn(ex, _task_id("SPANW"); kwargs...)
gw_spawn(f::Function; kwargs...) = _gw_spawn(f(), _task_id("SPANW"); kwargs...)

# ----------------------------------------------------------------
"""
    Capture the expression and spawn it
"""
macro gw_spawn(ex)
    GitWorkers.gw_spawn(ex; follow = true, tout = 120.0, wt = 5.0)
    return :(nothing)
end