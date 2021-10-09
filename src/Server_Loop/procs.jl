## ------------------------------------------------------
const _GITGW_SERVER_LOOP_PROC_TAG = "SERVER-LOOP"

_reg_server_loop_proc(; kwargs...) = _reg_proc(getpid(), _GITGW_SERVER_LOOP_PROC_TAG; kwargs...)
