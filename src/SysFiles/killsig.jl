# ------------------------------------------------------
# KILL SIG
_killsig_sysfile(pid) = _sysdir(string(pid, ".killsig"))

function _send_killsig(pid; unsafe = false) 
    fn = _killsig_sysfile(pid)
    return _write_toml(fn; pid, unsafe)
end

function _update_killsigs()
    for fn in readdir(_sysdir(); join = true)
        !endswith(fn, ".killsig") && continue
        sigdat = _read_toml(fn)
        regdat = get!(_SIGNALS_REGISTER, "killsig", Any[])
        push!(regdat, sigdat)
        _gwrm(fn)
    end
end

function _exec_killsigs()
    regdat = get!(_SIGNALS_REGISTER, "killsig", Any[])
    for sigdat in regdat
        pid = get(sigdat, "pid", -1)
        unsave = get(sigdat, "unsave", false)
        if unsave || _validate_proc(pid) 
            force_kill(pid)
        end
    end
    empty!(regdat)
end