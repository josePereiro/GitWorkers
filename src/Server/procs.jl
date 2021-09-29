## ------------------------------------------------------
# REGISTER PROC
const _GITGW_PROCREG_EXT = ".proc"
_procreg_name(pid, tag) = string(pid, ".", tag, _GITGW_PROCREG_EXT)
_is_procreg_file(fn) = endswith(fn, _GITGW_PROCREG_EXT)
function _parse_procreg_name(fn) 
    !_is_procreg_file(fn) && return ("", "", "")
    split_ = split(basename(fn), ".")
    (length(split_) == 3) ? split_ : ("", "", "")
end

_local_procreg(pid, tag) = _local_procsdir(_procreg_name(pid, tag))
_repo_procreg(pid, tag) = _repo_procsdir(_procreg_name(pid, tag))

_is_reg(pid, tag) = isfile(_local_procreg(pid, tag))

function _reg_proc(pid::Integer, tag::AbstractString;
        lstart::AbstractString = _get_proc_lstart(pid), 
        kwargs...
    )
    fn = _local_procreg(pid, tag)
    return !isfile(fn) && _write_toml(fn; pid, tag, lstart, kwargs...)
end

function _find_proc(pid)
    pid = string(pid)
    for procreg in _readdir(_local_procsdir(); join = true)
        pidi, tag, _ = _parse_procreg_name(procreg) 
        (pid == pidi) && return procreg
    end
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

## ------------------------------------------------------
const _GITGW_SERVER_MAIN_PROC_TAG = "SERVER-MAIN"
const _GITGW_SERVER_LOOP_PROC_TAG = "SERVER-LOOP"
const _GITGW_TASK_PROC_TAG = "TASK"

_reg_server_main_proc(; kwargs...) = _reg_proc(getpid(), _GITGW_SERVER_MAIN_PROC_TAG; kwargs...)
_reg_server_loop_proc(; kwargs...) = _reg_proc(getpid(), _GITGW_SERVER_LOOP_PROC_TAG; kwargs...)
_reg_task_proc(; kwargs...) = _reg_proc(getpid(), _GITGW_TASK_PROC_TAG; kwargs...)