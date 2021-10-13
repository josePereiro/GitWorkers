# ---------------------------------------------------------------
function _exec_bash(src)

    file = tempname()
    src = string("rm -f \"$(file)\"\n", src)
    src = _format_src(src)
    write(file, src)
    chmod(file, 0x777)

    run(`bash -c $(file)`; wait = true)
    return nothing
end

# ---------------------------------------------------------------
function _set_bash_task(taskid, src)
    expr = quote 
        begin
            GitWorkers._exec_bash($(src))
        end 
    end
    _set_jlexpr_task(taskid, expr)
    return nothing
end

