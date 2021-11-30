const _GW_TASK_FILE_NAME = "task.toml"
_task_file(taskdir::String) = joinpath(taskdir, _GW_TASK_FILE_NAME)

const _GW_TASK_TID_KEY = "tid"
const _GW_TASK_EXPTIME_KEY = "exptime"
const _GW_TASK_RUNSTATE_KEY = "runstate"

const _GW_TASK_PENDING_RUNSTATE = "pending"
const _GW_TASK_RUNNING_RUNSTATE = "running"
const _GW_TASK_DONE_RUNSTATE = "done"
const _GW_TASK_ERROR_RUNSTATE = "error"
