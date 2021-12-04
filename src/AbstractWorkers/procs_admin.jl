const _GW_PROC_REG_INVALID_HASH = "INVALID"

_proc_reg_name(rid::String, pid::Integer, vhash::String) = _nusv_file_name(rid, pid, vhash)
function _parse_proc_reg_name(prn::String)
    dig = _parse_nusv(prn)
    length(dig) != 3 && return (;rid = "", pid = -1, vhash = _GW_PROC_REG_INVALID_HASH)
    rid = dig[1]
    pid = _tryparse(Int, dig[2], -1)
    vhash = dig[3]
    return (;rid, pid, vhash)
end

function _get_pid_vhash(pid::Integer)
    # lstart is use as validation of a running pid register
    lstart = _get_proc_lstart(pid)
    vhash = isempty(lstart) ? _GW_PROC_REG_INVALID_HASH : string(hash(lstart))
    return vhash
end

function _reg_proc(w::AbstractWorker, rid::String, pid::Integer = getpid())

    # reg file
    pdir = procs_dir(w)
    vhash = _get_pid_vhash(pid)
    rname = _proc_reg_name(rid, pid, vhash)
    rfile = joinpath(pdir, rname)
    _mkdir(rfile)
    touch(rfile)

    return rfile
end

function _find_proc_reg(w::AbstractWorker, hint)
    pdir = procs_dir(w)
    for rname in _readdir(pdir)
        _has_usvvalue(rname, hint) && return joinpath(pdir, rname) 
    end
    return ""
end

function _read_proc_reg(w::AbstractWorker, hint)
    # reg file
    rfile = _find_proc_reg(w, hint)
    _parse_proc_reg_name(rfile)
end

function _is_valid_proc(rfile::String)
    rid, pid, rvhash = _parse_proc_reg_name(rfile)
    svhash = _get_pid_vhash(pid)
    isvalid = (svhash == rvhash) && (rvhash != _GW_PROC_REG_INVALID_HASH)
    !isvalid && rm(rfile; force = true)
    return isvalid
end
_is_valid_proc(w::AbstractWorker, hint) = _is_valid_proc(_find_proc_reg(w, hint))

function _safe_kill(rfile)
    !_is_valid_proc(rfile) && return false
    rid, pid, _ = _parse_proc_reg_name(rfile)
    pid == -1 && return false
    mypid = getpid()
    (mypid == pid) && return false
    return _force_kill(pid)
end
_safe_kill(w::AbstractWorker, phint) = _safe_kill(_find_proc_reg(w, phint))

function _kill_duplicated_procs(w::AbstractWorker)
    pdir = procs_dir(w)
    rids = String[]
    for rfile in _readdir(pdir; join = true)
        rid, pid, rvhash = _parse_proc_reg_name(rfile)
        if (rid in rids)
            _safe_kill(rfile)
            push(rids, rid)
        end
    end
    return nothing
end

function _del_invalid_proc_regs(w::AbstractWorker)
    pdir = procs_dir(w)
    for rfile in _readdir(pdir; join = true)
        !_is_valid_proc(rfile) && rm(rfile; force = true)
    end
    return nothing
end