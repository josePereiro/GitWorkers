macro gitworker(ex)
    !Meta.isexpr(ex, :let) && error("A let block was expected. Ex: '@gitworker let println(\"Hi\")' end")
    
    cmdid = _gen_id()
    cmdfile = _gitwr_cmd_file(cmdid)
    serialize(cmdfile, ex)
    _gwsync(;force_clonning = false)

    return :(nothing)
end