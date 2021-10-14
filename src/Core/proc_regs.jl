## ------------------------------------------------------
# REGISTER PROC
const _GW_PROCREG_EXT = ".proc"
_procreg_name(pid, tag) = string(pid, ".", tag, _GW_PROCREG_EXT)

const _GW_PROCREG_NAME_REGEX = Regex("^(?<pid>[0-9]+)\\.(?<tag>.*)(?<ext>\\.proc)\$")
_is_procreg_file(fn) = !isnothing(match(_GW_PROCREG_NAME_REGEX, basename(fn)))

function _parse_procreg_name(fn) 
    m = match(_GW_PROCREG_NAME_REGEX, basename(fn))
    return isnothing(m) ? ("", "", "") : (m[:pid], m[:tag], m[:ext])
end

_local_procreg(pid, tag) = _local_procs_dir(_procreg_name(pid, tag))
_repo_procreg(pid, tag) = _repo_procs_dir(_procreg_name(pid, tag))

_is_reg(pid, tag) = isfile(_local_procreg(pid, tag))

function _reg_proc(pid::Integer, tag::AbstractString;
        lstart::AbstractString = _get_proc_lstart(pid), 
        kwargs...
    )
    regfile = _local_procreg(pid, tag)
    _on_content_event(regfile; atmissing = true) do
        _write_toml(regfile; pid, tag, lstart, kwargs...)
    end
end

function _find_procreg(pid, tag = ""; procsdir = _local_procs_dir())
    pid = string(pid)
    isempty(pid) && return ""
    for procreg in _readdir(procsdir; join = true)
        pidi, tagi, _ = _parse_procreg_name(procreg)
        isempty(tag) && (tagi = tag) # ignore tag
        (pid == pidi) && (tag == tagi) && return procreg
    end
    return ""
end

function _validate_proc(regfile)

    !isfile(regfile) && return false
    !_is_procreg_file(regfile) && return false

    dat = _read_toml(regfile)
    reg_lstart = get(dat, "lstart", "MISSING")
    pid = get(dat, "pid", "-1")
    
    curr_lstart = _get_proc_lstart(pid)
    
    return reg_lstart == curr_lstart
end

function _no_proc_running(f::Function)
    procdir = _local_procs_dir()
    serverprocs = _filterdir(procdir; join = true) do regfile
        _validate_proc(regfile) && f(regfile)
    end
    return length(serverprocs)
end

function _kill_all_procs(procdir = _local_procs_dir())
    _readdir(procdir; join = true) do procreg
        pidi, tagi, _ = _parse_procreg_name(procreg)
        isempty(pidi) && return
        _safe_kill(pid; unsafe = false)
    end
    
end

