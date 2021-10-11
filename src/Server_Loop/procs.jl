## ------------------------------------------------------
const _GW_SERVER_LOOP_PROC_TAG = "SERVER-LOOP"

_reg_server_loop_proc(; kwargs...) = _reg_proc(getpid(), _GW_SERVER_LOOP_PROC_TAG; kwargs...)
