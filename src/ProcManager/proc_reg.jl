const _PROC_REG_RKEY = "proc_reg"

const _PROC_REG_EXT = ".proc.toml"
_proc_reg_file(gw::GitWorker, pid, rid) = joinpath(gw_procs_dir(gw), string(pid, ".", rid, _PROC_REG_EXT))
_is_proc_reg_file(fn) = endswith(fn, _PROC_REG_EXT)

function _reg_proc!(gw::GitWorker, pid, rid)

    # reg file
    rfile = _proc_reg_file(gw, rid, pid)

    # get proc info
    lstart = _get_proc_lstart(pid)
    isempty(lstart) && return false

    # up ram
    sdat = reg_sdat!(gw, rfile; 
        rid, lstart, pid
    )
    
    # up disk
    _mkdir(rfile)
    _write_toml(rfile, sdat)

    return rfile
end

function _find_proc_reg(gw::GitWorker, khint)
    khint = basename(string(khint))
    pdir = gw_procs_dir(gw)
    _find_by_khint(gw, pdir, khint)
end

function _up_procs_from_disk(gw::GitWorker)
    pdir = gw_procs_dir(gw)
    empty_sreg!(gw, pdir) 
    for path in _readdir(pdir; join = true)
        !_is_proc_reg_file(path) && continue
        fdat = _read_toml(path)
        !haskey(fdat, "pid") && continue
        reg_sdat!(gw, path, fdat)
    end
    return gw
end 

function _validate_proc(gw::GitWorker, phint)
    pdat = _find_proc_reg(gw, phint)
    isempty(pdat) && return false
    rlstart = get(pdat, "lstart", "")
    isempty(rlstart) && return false
    pid = get(pdat, "pid", "")
    isempty(pid) && return false
    clstart = _get_proc_lstart(pid)
    isempty(clstart) && return false
    return rlstart == clstart
end