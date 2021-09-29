function gw_send_standby()
    _repo_update() do
        _set_pushflag()
        _send_standby_sig()
        return true
    end
end

function gw_clear_standby()
    _repo_update() do
        _clear_standby_sig()
        return true
    end
end