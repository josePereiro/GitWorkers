## ------------------------------------------------------------------
function _set_long_task(taskid, ex::Expr)
    
    !Meta.isexpr(ex, :block) && error("A 'begin' block was expected. Ex: '@gitworker begin println(\"Hi\")' end")

    taskfile = _repo_long_task_file(taskid)
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