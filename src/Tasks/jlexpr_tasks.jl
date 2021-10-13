## ------------------------------------------------------------------
const _GW_LONG_TASK_EXT = ".task"

_jlexpr_task_name(taskid) = string(taskid, _GW_LONG_TASK_EXT)
_is_jlexpr_task_name(fn) = _endswith(fn, _GW_LONG_TASK_EXT)
function _parse_jlexpr_task_name(fn)
    !_is_jlexpr_task_name(fn) && return ["", ""]
    _split = split(basename(fn), ".")
    return (length(_split) == 2) ? string.(_split) : ["", ""]
end
_repo_jlexpr_task_file(taskid) = _repo_tasks_cmds_dir(_jlexpr_task_name(taskid))
_local_jlexpr_task_file(taskid) = _local_tasks_cmds_dir(_jlexpr_task_name(taskid))

## ------------------------------------------------------------------
const _GW_EXPR_FILE_EXT = ".expr"
_expr_name(taskid) = string(taskid, _GW_EXPR_FILE_EXT)
_is_expr_name(fn) = _endswith(fn, _GW_EXPR_FILE_EXT)

_local_expr_file(taskid) = _local_tasks_exprs_dir(_expr_name(taskid))
