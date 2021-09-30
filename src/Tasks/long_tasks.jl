## ------------------------------------------------------------------
const _GW_LONG_TASK_EXT = ".task"

_long_task_name(taskid) = string(taskid, _GW_LONG_TASK_EXT)
_is_long_task_name(fn) = endswith(fn, _GW_LONG_TASK_EXT)
function _parse_long_task_name(fn)
    !_is_long_task_name(fn) && return ["", ""]
    _split = split(basename(fn), ".")
    return (length(_split) == 2) ? string.(_split) : ["", ""]
end
_repo_long_task_file(taskid) = _repo_tasksdir(_long_task_name(taskid))
_local_long_task_file(taskid) = _local_tasksdir(_long_task_name(taskid))
