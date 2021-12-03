const _PROC_REG_RKEY = "proc_reg"

const _PROC_REG_EXT = ".proc.toml"
_proc_reg_file(w::AbstractWorker, pid, rid) = joinpath(procs_dir(w), string(pid, ".", rid, _PROC_REG_EXT))
_is_proc_reg_file(fn) = endswith(fn, _PROC_REG_EXT)

function _reg_proc!(w::AbstractWorker, pid, rid)

    # reg file
    rfile = _proc_reg_file(w, rid, pid)

    # get proc info
    lstart = _get_proc_lstart(pid)
    isempty(lstart) && return false

    # up ram
    sdat = reg_sdat!(w, rfile; 
        rid, lstart, pid
    )
    
    # up disk
    _mkdir(rfile)
    _write_toml(rfile, sdat)

    return rfile
end

function _find_proc_reg(w::AbstractWorker, khint)
    khint = basename(string(khint))
    pdir = procs_dir(w)
    _find_by_khint(w, pdir, khint)
end

function _up_procs_from_disk(w::AbstractWorker)
    pdir = procs_dir(w)
    empty_sreg!(w, pdir) 
    for path in _readdir(pdir; join = true)
        !_is_proc_reg_file(path) && continue
        fdat = _read_toml(path)
        !haskey(fdat, "pid") && continue
        reg_sdat!(w, path, fdat)
    end
    return w
end

function _validate_proc(w::AbstractWorker, phint)
    pdat = _find_proc_reg(w, phint)
    isempty(pdat) && return false
    rlstart = get(pdat, "lstart", "")
    isempty(rlstart) && return false
    pid = get(pdat, "pid", "")
    isempty(pid) && return false
    clstart = _get_proc_lstart(pid)
    isempty(clstart) && return false
    return rlstart == clstart
end

function _safe_kill(w::AbstractWorker, phint)
    pdat = _find_proc_reg(w, phint)
    pid = get!(pdat, "pid", "-1")
    (pid == "-1") && return false
    if _validate_proc(w, pid)
        return _force_kill(pid)
    end
    return false
end