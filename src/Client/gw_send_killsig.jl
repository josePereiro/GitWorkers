function gw_set_killsig(pid; verb = false)
    
    _repo_update(;verb) do
        _set_pushflag()
        _set_killsig(pid)

        return true
    end
end