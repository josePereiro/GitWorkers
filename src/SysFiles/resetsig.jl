# ------------------------------------------------------
# RESET SIG
_resetsig_sysfile() = _sysdir(".resetsig")

function _send_resetsig(;update = false)
    fn =_resetsig_sysfile()
    return _write_toml(fn; update)
end

function _update_resetsig()
    fn = _resetsig_sysfile()
    if isfile(fn)
        sigdat = _read_toml(fn)
        _SIGNALS_REGISTER["resetsig"] = sigdat
        _gwrm(fn)
    end
end

function _exec_resetsig()
    if haskey(_SIGNALS_REGISTER, "resetsig")
        sigdat = _SIGNALS_REGISTER["resetsig"]
        update = get(sigdat, "update", false)
        empty!(sigdat)
        update && _update_urlproject()
        _server_loop_exit()
    end
end