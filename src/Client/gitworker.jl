macro gitworker(ex)
    !Meta.isexpr(ex, :let) && error("A let block was expected. Ex: '@gitworker let println(\"Hi\")' end")
    
    cmdid = _gen_id()
    cmdfile = _gitwr_cmd_file(cmdid)
    _try_sync(;force_clonning = false) do
        serialize(cmdfile, ex)
    end

    return :(nothing)
end