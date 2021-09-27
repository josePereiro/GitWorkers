function gw_send_killsig(pid)
    _repo_update() do
        _set_pushflag()
        _send_killsig(pid)
    end
end