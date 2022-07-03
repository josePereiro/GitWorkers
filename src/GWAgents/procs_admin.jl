## ---------------------------------------------------
# register proccess
const _GW_PROC_REG_INVALID_HASH = "INVALID"

_proc_reg_name(agent_ider::String, pid::Integer, vhash::String) = _nusv_file_name(agent_ider, pid, vhash)

function _parse_proc_reg_name(prn::String)
    dig = _parse_nusv(prn)
    length(dig) != 3 && return (;agent_ider = "", pid = -1, vhash = _GW_PROC_REG_INVALID_HASH)
    agent_ider = dig[1]
    pid = _tryparse(Int, dig[2], -1)
    vhash = dig[3]
    return (;agent_ider, pid, vhash)
end

function _reg_proc(w::AbstractGWAgent, agent_ider::String = agent_ider(w), pid::Integer = getpid())

    # reg file
    pdir = procs_dir(w)
    vhash = _get_pid_vhash(pid)
    rname = _proc_reg_name(agent_ider, pid, vhash)
    rfile = joinpath(pdir, rname)
    _mkdir(rfile)
    touch(rfile)

    return rfile
end

# lstart is use as validation of a running pid register
function _get_pid_vhash(pid::Integer)
    lstart = _get_proc_lstart(pid)
    vhash = isempty(lstart) ? _GW_PROC_REG_INVALID_HASH : string(hash(lstart))
    return vhash
end

## ---------------------------------------------------
# Utils
function _findfirst_proc_reg(w::AbstractGWAgent, hint)
    pdir = procs_dir(w)
    for rname in _readdir(pdir)
        _has_usvvalue(rname, hint) && return joinpath(pdir, rname) 
    end
    return ""
end

function _findall_proc_reg(w::AbstractGWAgent, hint)
    pdir = procs_dir(w)
    found = String[]
    for rname in _readdir(pdir)
        if _has_usvvalue(rname, hint) 
            push!(found, joinpath(pdir, rname))
        end
    end
    return found
end

function _read_proc_reg(w::AbstractGWAgent, hint)
    # reg file
    rfile = _findfirst_proc_reg(w, hint)
    _parse_proc_reg_name(rfile)
end

function _is_valid_proc(rfile::String)
    isfile(rfile) || return false
    _, pid, rvhash = _parse_proc_reg_name(rfile)
    svhash = _get_pid_vhash(pid)
    isvalid = (svhash == rvhash) && (rvhash != _GW_PROC_REG_INVALID_HASH)
    !isvalid && _rm(rfile)
    return isvalid
end
_is_valid_proc(w::AbstractGWAgent, hint) = _is_valid_proc(_findfirst_proc_reg(w, hint))

_is_running(w::AbstractGWAgent, hint) = _is_valid_proc(w, hint)

function _safe_kill(rfile)
    !_is_valid_proc(rfile) && return false
    _, pid, _ = _parse_proc_reg_name(rfile)
    pid == -1 && return false
    mypid = getpid()
    (mypid == pid) && return false
    return _force_kill(pid)
end
_safe_kill(w::AbstractGWAgent, phint) = _safe_kill(_findfirst_proc_reg(w, phint))

function _safe_killall(w::AbstractGWAgent, hint)
    reg_files = _findall_proc_reg(w, hint)
    for file in reg_files
        _safe_kill(file)
    end
end

function _kill_duplicated_procs(w::AbstractGWAgent)
    pdir = procs_dir(w)
    rids = String[]
    cptag = agent_ider(w)
    for rfile in _readdir(pdir; join = true)
        agent_ider, _, _ = _parse_proc_reg_name(rfile)
        
        if cptag == agent_ider 
            _safe_kill(rfile)
            continue
        end
        
        if (agent_ider in rids)
            _safe_kill(rfile)
        else
            push!(rids, agent_ider)
        end
    end
    return nothing
end

function _del_invalid_proc_regs(w::AbstractGWAgent)
    pdir = procs_dir(w)
    for rfile in _readdir(pdir; join = true)
        !_is_valid_proc(rfile) && _rm(rfile)
    end
    return nothing
end
