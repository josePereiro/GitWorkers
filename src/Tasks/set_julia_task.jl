# ---------------------------------------------------------------
# JULIA
function _exec_julia(src)

    file = tempname()
    src = string("rm(\"$(file)\"; force = true)\n", src)
    src = _format_src(src)
    write(file, src)
    chmod(file, 0x777)

    # TODO: manage julia run enviroments
    julia = Base.julia_cmd()
    proj = Base.active_project()
    jlcmd = Cmd(`$julia --startup-file=no --project=$(proj) -- $(file)`)
    run(jlcmd; wait = true)

    return nothing
end

# ---------------------------------------------------------------
function _set_julia_task(taskid, src)
    expr = quote 
        begin
            GitWorkers._exec_julia($(src))
        end 
    end
    _set_jlexpr_task(taskid, expr)
    return nothing
end