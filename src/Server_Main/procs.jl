## ------------------------------------------------------
const _GW_SERVER_MAIN_PROC_TAG = "SERVER-MAIN"

_reg_server_main_proc(; kwargs...) = _reg_proc(getpid(), _GW_SERVER_MAIN_PROC_TAG; kwargs...)