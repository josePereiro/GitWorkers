# ----------------------------------------------------------------
const _LAST_SPAWED_TASKID = Ref{String}("")

_set_last_task(taskid) = (_LAST_SPAWED_TASKID[] = string(taskid))
_get_last_task() = _LAST_SPAWED_TASKID[]

gw_last_task() = _get_last_task()
