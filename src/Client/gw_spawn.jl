# ----------------------------------------------------------------
"""
    Take an expression and spawn it
"""
function _gw_spawn(gw::GitWorker, ex::Expr, tname; 
        follow = true, tout = 120.0,
        wt = 5.0, verb = false
    )

    !Meta.isexpr(ex, [:let, :block]) && error("A 'begin or let' block is expected. Ex: '@gw_spawn begin println(\"Hi\")' end")

    gl = gitlink(gw)

    writewdir(gl; tout) do _

        tid = _task_id(tname)
        ltdir = task_dir(gw, tid)
        rtdir = repo_mirpath(gw, ltdir)
        gwt = GWTask(tid, rtdir)

        _write_task(gwt, ex;
            desc = "Hiiiiii", lang = "julia",
            src = _expr_src(ex),
            readme = true
        )
    end

    return :(nothing)
end

_gw_spawn(f::Function, gw::GitWorker, tname; kwargs...) = _gw_spawn(gw, f(), tname; kwargs...)

"""
    Take the return f()::Expr and spawn it
"""
gw_spawn(ex::Expr; kwargs...) = _gw_spawn(gw_curr(), ex, "SPAWN"; kwargs...)
gw_spawn(f::Function; kwargs...) = _gw_spawn(f(), gw_curr(), "SPAWN"; kwargs...)

# ----------------------------------------------------------------
"""
    Capture the expression and spawn it
"""
macro gw_spawn(ex)
    GitWorkers.gw_spawn(ex; follow = true, tout = 120.0, wt = 5.0)
    return :(nothing)
end