function gw_send_killsig(pid; deb = false)
    
    ios = deb ? [stdout] : []
    _repo_update(;ios) do
        _set_pushflag()
        _send_killsig(pid)

        return true
    end
end