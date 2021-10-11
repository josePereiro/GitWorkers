function _safe_kill(pid; unsafe = false)
    pid = string(pid)
    unsafe && (_force_kill(pid); return)
    procreg = _find_procreg(pid; procsdir = _repo_procs_dir())
    _validate_proc(procreg) && _force_kill(pid)
end

