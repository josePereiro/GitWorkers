## ------------------------------------------------------------------
function _set_jlexpr_task(taskid, ex::Expr)

    taskfile = _repo_jlexpr_task_file(taskid)
    _gw_task__ = (;
        id = taskid, 
        taskfile = _rel_urlpath(taskfile) # This is run in client
    )

    expr = quote
        _gw_task__ = $(_gw_task__)
        $(ex)
        return nothing
    end

    taskcmd = (;
        id = taskid, 
        taskfile = _rel_urlpath(taskfile),
        expr
    )

    serialize(taskfile, taskcmd)

end