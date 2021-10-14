## ------------------------------------------------------
const _GW_TASK_PROC_TAG = "TASK"

_reg_task_proc(; kwargs...) = _reg_proc(getpid(), _GW_TASK_PROC_TAG; kwargs...)

function _is_task_procreg(fn)
    pid, tag, _ = _parse_procreg_name(fn)
    isempty(pid) && return false
    return tag == _GW_TASK_PROC_TAG
end

function _check_duplicated_task_proc(curr_taskid)
    noprocs = _no_proc_running() do regfile
        !contains(regfile, _GW_TASK_PROC_TAG) && return false
        regdat = _read_toml(regfile)
        reg_taskid = get(regdat, "taskid", "")
        return (reg_taskid == curr_taskid)
    end

    if (noprocs > 1)
        error("FATAL, more than one process is running task '$(curr_taskid)'")
    end
end