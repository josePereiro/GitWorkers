function _safe_kill(gw::GitWorker, phint)
    pdat = _find_proc_reg(gw, phint)
    pid = get!(pdat, "pid", "-1")
    (pid == "-1") && return false
    if _validate_proc(gw, pid)
        return _force_kill(pid)
    end
    return false
end