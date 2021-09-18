macro gitworker(ex)
    !Meta.isexpr(ex, :let) && error("A let block was expected. Ex: '@gitworker let println(\"Hi\")' end")
    
    cmdid = _rand_cmd_id()
    cmd_file = _gitwr_cmd_file(cmdid)
    _locked_sync_gitwr!(cmdid; verb=true) do
        serialize(cmd_file, ex)
    end

    return :(nothing)
end