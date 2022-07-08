# ----------------------------------------------------------------
"""
    Take an expression and spawn it
"""
function _gw_spawn(gw::GitWorker, ex::Expr, tname; 
        follow = true, tout = Inf
    )

    rtrt = _upload_task(gw, tname; ex)
    isnothing(rtrt) && (@info("Task uploading failed", taskid = agent_ider(rtrt)); return)

    
    @info("Task uploaded successfully", taskid = agent_ider(rtrt))
    follow && @info("Following")
    follow && _pull_and_listen(gw, rtrt; tout) 

    gw_curr_task!(rtrt)

    return nothing

end

_gw_spawn(f::Function, gw::GitWorker, tname; kwargs...) = _gw_spawn(gw, f(), tname; kwargs...)

"""
    Take the return f()::Expr and spawn it
"""
gw_spawn(ex::Expr; kwargs...) = _gw_spawn(gw_curr(), ex, "SPAWN"; kwargs...)
gw_spawn(f::Function; kwargs...) = _gw_spawn(gw_curr(), f(), "SPAWN"; kwargs...)

# ----------------------------------------------------------------
"""
    Capture the expression and spawn it
"""
macro gw_spawn(ex)
    !Meta.isexpr(ex, [:let, :block]) && error("A 'begin or let' block is expected. Ex: '@gw_spawn begin println(\"Hi\")' end")
    GitWorkers.gw_spawn(ex; follow = true, tout = Inf)
end