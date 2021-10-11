## ------------------------------------------------------
const _GW_TASK_PROC_TAG = "TASK"

_reg_task_proc(; kwargs...) = _reg_proc(getpid(), _GW_TASK_PROC_TAG; kwargs...)

function _is_task_procreg(fn)
    pid, tag, _ = _parse_procreg_name(fn)
    isempty(pid) && return false
    return tag == _GW_TASK_PROC_TAG
end