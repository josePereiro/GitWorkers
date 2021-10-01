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

## ------------------------------------------------------------------
const _GW_EXPR_FILE_EXT = ".expr"
_expr_name(taskid) = string(taskid, _GW_EXPR_FILE_EXT)
_is_expr_name(fn) = endswith(fn, _GW_EXPR_FILE_EXT)

_local_expr_file(taskid) = _local_exprsdir(_expr_name(taskid))
