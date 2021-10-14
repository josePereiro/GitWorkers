# ------------------------------------------------------------------
function _spawn_jlexpr_task(taskid, taskfile)

    # setup
    sysroot = _get_root()
    url = _get_url()
    
    # TODO: Connect proj with config
    projdir = Base.active_project()

    # out
    out_file = _local_task_out_file(taskid)
    
    # unregister task
    raskcmd = deserialize(taskfile)
    _rm(taskfile)
    exprfile = _local_expr_file(taskid)
    serialize(exprfile, raskcmd.expr)
    
    # TODO: connect with config for julia cmd
    scriptfile = joinpath(@__DIR__, "jlexpr_task_script.jl")
    julia = Base.julia_cmd()
    jlcmd = Cmd(`$julia --startup-file=no --project=$(projdir) -- $(scriptfile) $(taskid) $(exprfile) $(sysroot) $(url)`; detach = false)
    jlcmd = pipeline(jlcmd; stdout = out_file, stderr = out_file, append = true)
    println("\n\n", "spawing task ", taskid, "\n\n")
    run(jlcmd; wait = false)

    return nothing

end