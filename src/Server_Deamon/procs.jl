## ------------------------------------------------------
const _GW_DEAMON_PROC_TAG = "DEAMON"

_reg_deamon_proc(; kwargs...) = _reg_proc(getpid(), _GW_DEAMON_PROC_TAG; kwargs...)
