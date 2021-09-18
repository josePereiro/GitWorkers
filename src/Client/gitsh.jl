macro gitsh(ex)
    !Meta.isexpr(ex, :let) && error("A let block was expected. Ex: '@gitsh let println(\"Hi\")' end")
    
    cmdid = _rand_cmd_id()
    cmd_file = _gitsh_cmd_file(cmdid)
    _locked_sync_gitsh!(cmdid; verb=true) do
        serialize(cmd_file, ex)
    end

    return :(nothing)
end