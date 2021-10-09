## ------------------------------------------------------
# REGISTER PROC
const _GITGW_PROCREG_EXT = ".proc"
_procreg_name(pid, tag) = string(pid, ".", tag, _GITGW_PROCREG_EXT)
_is_procreg_file(fn) = _endswith(fn, _GITGW_PROCREG_EXT)
function _parse_procreg_name(fn) 
    !_is_procreg_file(fn) && return ("", "", "")
    split_ = split(basename(fn), ".")
    (length(split_) == 3) ? split_ : ("", "", "")
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
    for procreg in _readdir(procsdir; join = true)
        pidi, tagi, _ = _parse_procreg_name(procreg)
        isempty(tag) && (tagi = tag) # ignore tag
        (pid == pidi) && (tag == tagi) && return procreg
    end
    return ""
end

# validate if a proc is active and is registered
function _validate_proc(pid, tag)
    isempty(string(pid)) && return false
    fn = _local_procreg(pid, tag)
    dat = _read_toml(fn)
    reg_lstart = get(dat, "lstart", "MISSING")
    curr_lstart = _get_proc_lstart(pid)
    reg_lstart == curr_lstart
end

function _validate_proc(fn)
    pid, tag, _ = _parse_procreg_name(fn) 
    _validate_proc(pid, tag)
end

function _no_proc_running(hint)
    hint = string(hint)
    serverprocs = _filterdir(_local_procs_dir()) do file
        _is_procreg_file(file) && contains(file, hint) && _validate_proc(file)
    end
    return length(serverprocs)
end
