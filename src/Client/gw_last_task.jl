# ----------------------------------------------------------------
const _LAST_SPAWED_TASK = Ref{String}("")

_set_last_task(taskid) = (_LAST_SPAWED_TASK[] = string(taskid))
_get_last_task() = _LAST_SPAWED_TASK[]

gw_last_task() = _get_last_task()
