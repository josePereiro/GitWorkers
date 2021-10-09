## ------------------------------------------------------
const _GITGW_TASK_PROC_TAG = "TASK"

_reg_task_proc(; kwargs...) = _reg_proc(getpid(), _GITGW_TASK_PROC_TAG; kwargs...)
